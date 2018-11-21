[@@@ocaml.warning "-27-30-39"]

type bytes_list_mutable = {
  mutable value : bytes list;
}

let default_bytes_list_mutable () : bytes_list_mutable = {
  value = [];
}

type float_list_mutable = {
  mutable value : float list;
}

let default_float_list_mutable () : float_list_mutable = {
  value = [];
}

type int64_list_mutable = {
  mutable value : int64 list;
}

let default_int64_list_mutable () : int64_list_mutable = {
  value = [];
}

type features_mutable = {
  mutable feature : (string * Feature_types.feature) list;
}

let default_features_mutable () : features_mutable = {
  feature = [];
}

type feature_list_mutable = {
  mutable feature : Feature_types.feature list;
}

let default_feature_list_mutable () : feature_list_mutable = {
  feature = [];
}

type feature_lists_mutable = {
  mutable feature_list : (string * Feature_types.feature_list) list;
}

let default_feature_lists_mutable () : feature_lists_mutable = {
  feature_list = [];
}


let rec decode_bytes_list d =
  let v = default_bytes_list_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      v.value <- List.rev v.value;
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.value <- (Pbrt.Decoder.bytes d) :: v.value;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(bytes_list), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Feature_types.value = v.value;
  } : Feature_types.bytes_list)

let rec decode_float_list d =
  let v = default_float_list_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      v.value <- List.rev v.value;
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.value <- Pbrt.Decoder.packed_fold (fun l d -> (Pbrt.Decoder.float_as_bits32 d)::l) [] d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(float_list), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Feature_types.value = v.value;
  } : Feature_types.float_list)

let rec decode_int64_list d =
  let v = default_int64_list_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      v.value <- List.rev v.value;
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.value <- Pbrt.Decoder.packed_fold (fun l d -> (Pbrt.Decoder.int64_as_varint d)::l) [] d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(int64_list), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Feature_types.value = v.value;
  } : Feature_types.int64_list)

let rec decode_feature d = 
  let rec loop () = 
    let ret:Feature_types.feature = match Pbrt.Decoder.key d with
      | None -> Pbrt.Decoder.malformed_variant "feature"
      | Some (1, _) -> Feature_types.Bytes_list (decode_bytes_list (Pbrt.Decoder.nested d))
      | Some (2, _) -> Feature_types.Float_list (decode_float_list (Pbrt.Decoder.nested d))
      | Some (3, _) -> Feature_types.Int64_list (decode_int64_list (Pbrt.Decoder.nested d))
      | Some (n, payload_kind) -> (
        Pbrt.Decoder.skip d payload_kind; 
        loop () 
      )
    in
    ret
  in
  loop ()

let rec decode_features d =
  let v = default_features_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      v.feature <- List.rev v.feature;
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      let decode_value = (fun d ->
        decode_feature (Pbrt.Decoder.nested d)
      ) in
      v.feature <- (
        (Pbrt.Decoder.map_entry d ~decode_key:Pbrt.Decoder.string ~decode_value)::v.feature;
      );
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(features), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Feature_types.feature = v.feature;
  } : Feature_types.features)

let rec decode_feature_list d =
  let v = default_feature_list_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      v.feature <- List.rev v.feature;
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.feature <- (decode_feature (Pbrt.Decoder.nested d)) :: v.feature;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(feature_list), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Feature_types.feature = v.feature;
  } : Feature_types.feature_list)

let rec decode_feature_lists d =
  let v = default_feature_lists_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      v.feature_list <- List.rev v.feature_list;
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      let decode_value = (fun d ->
        decode_feature_list (Pbrt.Decoder.nested d)
      ) in
      v.feature_list <- (
        (Pbrt.Decoder.map_entry d ~decode_key:Pbrt.Decoder.string ~decode_value)::v.feature_list;
      );
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(feature_lists), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Feature_types.feature_list = v.feature_list;
  } : Feature_types.feature_lists)

let rec encode_bytes_list (v:Feature_types.bytes_list) encoder = 
  List.iter (fun x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.bytes x encoder;
  ) v.Feature_types.value;
  ()

let rec encode_float_list (v:Feature_types.float_list) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.nested (fun encoder ->
    List.iter (fun x -> 
      Pbrt.Encoder.float_as_bits32 x encoder;
    ) v.Feature_types.value;
  ) encoder;
  ()

let rec encode_int64_list (v:Feature_types.int64_list) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.nested (fun encoder ->
    List.iter (fun x -> 
      Pbrt.Encoder.int64_as_varint x encoder;
    ) v.Feature_types.value;
  ) encoder;
  ()

let rec encode_feature (v:Feature_types.feature) encoder = 
  begin match v with
  | Feature_types.Bytes_list x ->
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_bytes_list x) encoder;
  | Feature_types.Float_list x ->
    Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_float_list x) encoder;
  | Feature_types.Int64_list x ->
    Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_int64_list x) encoder;
  end

let rec encode_features (v:Feature_types.features) encoder = 
  let encode_key = Pbrt.Encoder.string in
  let encode_value = (fun x encoder ->
    Pbrt.Encoder.nested (encode_feature x) encoder;
  ) in
  List.iter (fun (k, v) ->
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    let map_entry = (k, Pbrt.Bytes), (v, Pbrt.Bytes) in
    Pbrt.Encoder.map_entry ~encode_key ~encode_value map_entry encoder
  ) v.Feature_types.feature;
  ()

let rec encode_feature_list (v:Feature_types.feature_list) encoder = 
  List.iter (fun x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_feature x) encoder;
  ) v.Feature_types.feature;
  ()

let rec encode_feature_lists (v:Feature_types.feature_lists) encoder = 
  let encode_key = Pbrt.Encoder.string in
  let encode_value = (fun x encoder ->
    Pbrt.Encoder.nested (encode_feature_list x) encoder;
  ) in
  List.iter (fun (k, v) ->
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    let map_entry = (k, Pbrt.Bytes), (v, Pbrt.Bytes) in
    Pbrt.Encoder.map_entry ~encode_key ~encode_value map_entry encoder
  ) v.Feature_types.feature_list;
  ()
