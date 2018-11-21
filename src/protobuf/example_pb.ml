[@@@ocaml.warning "-27-30-39"]

type example_mutable = {
  mutable features : Feature_types.features option;
}

let default_example_mutable () : example_mutable = {
  features = None;
}

type sequence_example_mutable = {
  mutable context : Feature_types.features option;
  mutable feature_lists : Feature_types.feature_lists option;
}

let default_sequence_example_mutable () : sequence_example_mutable = {
  context = None;
  feature_lists = None;
}


let rec decode_example d =
  let v = default_example_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.features <- Some (Feature_pb.decode_features (Pbrt.Decoder.nested d));
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(example), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Example_types.features = v.features;
  } : Example_types.example)

let rec decode_sequence_example d =
  let v = default_sequence_example_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.context <- Some (Feature_pb.decode_features (Pbrt.Decoder.nested d));
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(sequence_example), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.feature_lists <- Some (Feature_pb.decode_feature_lists (Pbrt.Decoder.nested d));
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(sequence_example), field(2)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Example_types.context = v.context;
    Example_types.feature_lists = v.feature_lists;
  } : Example_types.sequence_example)

let rec encode_example (v:Example_types.example) encoder = 
  begin match v.Example_types.features with
  | Some x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (Feature_pb.encode_features x) encoder;
  | None -> ();
  end;
  ()

let rec encode_sequence_example (v:Example_types.sequence_example) encoder = 
  begin match v.Example_types.context with
  | Some x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (Feature_pb.encode_features x) encoder;
  | None -> ();
  end;
  begin match v.Example_types.feature_lists with
  | Some x -> 
    Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (Feature_pb.encode_feature_lists x) encoder;
  | None -> ();
  end;
  ()
