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

let write_event t ~step ~what =
  let encoder = P.Protobuf.Encoder.create () in
  let event =
    { P.Event_types.wall_time = Unix.time ()
    ; step = Int64.of_int step
    ; what
    }
  in
  P.Event_pb.encode_event event encoder;
  let data = P.Pbrt.Encoder.to_bytes encoder |> Bytes.to_string in
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

let create filename =
  let t =
    { out_channel = Out_channel.create filename
    }
  in
  write_event t ~step:0 ~what:(File_version "brain.Event:2");
  t

let write_value t ~step ~name ~value =
  let value =
    P.Summary_types.default_summary_value ~tag:name ~value:(Simple_value value) ()
  in
  let summary = P.Summary_types.default_summary ~value:[ value ] () in
  write_event t ~step ~what:(Summary summary)

let close t =
  Out_channel.close t.out_channel
