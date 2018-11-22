open Base
module P = Tensorboard_protobuf

type t = Tf_record_writer.t

let write_event t ~step ~what =
  let encoder = P.Protobuf.Encoder.create () in
  let event =
    { P.Event_types.wall_time = Unix.time ()
    ; step = Int64.of_int step
    ; what
    }
  in
  P.Event_pb.encode_event event encoder;
  Tf_record_writer.write t (P.Protobuf.Encoder.to_string encoder)

let create dirname =
  if not (Caml.Sys.file_exists dirname)
  then Unix.mkdir dirname 0o755;
  if Caml.Sys.file_exists dirname && not (Caml.Sys.is_directory dirname)
  then
    raise (Invalid_argument
      (Printf.sprintf "[create_dirname]: %s is not a directory" dirname));
  let basename =
    Printf.sprintf "out.tfevents.%d.%s"
      (Unix.time () |> Float.to_int)
      (Unix.gethostname ())
  in
  let filename = Caml.Filename.concat dirname basename in
  let t = Tf_record_writer.create ~filename in
  write_event t ~step:0 ~what:(File_version "brain.Event:2");
  t

let write_value t ~step ~name ~value =
  let value =
    P.Summary_types.default_summary_value ()
      ~tag:name ~value:(Simple_value value)
  in
  let summary = P.Summary_types.default_summary ~value:[ value ] () in
  write_event t ~step ~what:(Summary summary)

let write_text t ~step ~name ~text =
  let string_tensor =
    let tensor_shape =
      let one =
        P.Tensor_shape_types.default_tensor_shape_proto_dim ()
          ~size:Int64.one
      in
      P.Tensor_shape_types.default_tensor_shape_proto ~dim:[ one ] ()
    in
    P.Tensor_types.default_tensor_proto ()
      ~string_val:[ Bytes.of_string text ]
      ~dtype:Dt_string
      ~tensor_shape:(Some tensor_shape)
  in
  let metadata =
    let plugin_data =
      P.Summary_types.default_summary_metadata_plugin_data ()
        ~plugin_name:"text"
    in
    P.Summary_types.default_summary_metadata ~plugin_data:(Some plugin_data) ()
  in
  let value =
    P.Summary_types.default_summary_value ()
      ~metadata:(Some metadata)
      ~tag:(name ^ "/text_summary") ~value:(Tensor string_tensor)
  in
  let summary = P.Summary_types.default_summary ~value:[ value ] () in
  write_event t ~step ~what:(Summary summary)

let close = Tf_record_writer.close
