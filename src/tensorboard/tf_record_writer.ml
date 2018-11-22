open Base
open Stdio
module P = Tensorboard_protobuf

type t =
  { out_channel : Out_channel.t
  }

let int64_le_to_bytes i =
  let bigstring = Bigstringaf.create 8 in
  Bigstringaf.set_int64_le bigstring 0 (Int64.of_int i);
  Bigstringaf.substring bigstring ~off:0 ~len:8

let int32_le_to_bytes i =
  let bigstring = Bigstringaf.create 4 in
  Bigstringaf.set_int32_le bigstring 0 i;
  Bigstringaf.substring bigstring ~off:0 ~len:4

let crc32_mask i =
  Int32.bit_or
    (Int32.shift_right_logical i 15)
    (Int32.shift_left i 17)
  |> Int32.(+) (Int32.of_string "0xa282ead8")

let write t data =
  let data_length = String.length data in

  let data_length_str = int64_le_to_bytes data_length in
  let crc_data_length = Crc32c.string data_length_str 0 8 |> crc32_mask in
  let crc_data_length_str = int32_le_to_bytes crc_data_length in
  let crc_data = Crc32c.string data 0 data_length |> crc32_mask in
  let crc_data_str = int32_le_to_bytes crc_data in

  Out_channel.output_string t.out_channel data_length_str;
  Out_channel.output_string t.out_channel crc_data_length_str;
  Out_channel.output_string t.out_channel data;
  Out_channel.output_string t.out_channel crc_data_str;
  Out_channel.flush t.out_channel

let create ~filename =
  { out_channel = Out_channel.create filename
  }

let close t =
  Out_channel.close t.out_channel

type feature = [ `f of float list | `b of bytes list | `i of Int64.t list ]

let make_feature = function
  | `f value -> P.Feature_types.Float_list { value }
  | `b value -> P.Feature_types.Bytes_list { value }
  | `i value -> P.Feature_types.Int64_list { value }

let feature_of_example example =
  List.map example ~f:(fun (name, feature) ->
      name, make_feature feature)

let write_example t example =
  let encoder = P.Protobuf.Encoder.create () in
  let feature = feature_of_example example in
  P.Example_pb.encode_example { features = Some { feature } } encoder;
  write t (P.Protobuf.Encoder.to_string encoder)

let write_sequence_example t ~context ~feature_lists =
  let encoder = P.Protobuf.Encoder.create () in
  let feature_list =
    List.map feature_lists ~f:(fun (name, feature_list) ->
        let feature = List.map feature_list ~f:make_feature in
        name, { P.Feature_types.feature })
  in
  P.Example_pb.encode_sequence_example
    { context = Some { feature = feature_of_example context }
    ; feature_lists = Some { feature_list }
    }
    encoder;
  write t (P.Protobuf.Encoder.to_string encoder)
