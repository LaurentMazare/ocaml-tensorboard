(** example.proto Binary Encoding *)


(** {2 Protobuf Encoding} *)

val encode_example : Example_types.example -> Pbrt.Encoder.t -> unit
(** [encode_example v encoder] encodes [v] with the given [encoder] *)

val encode_sequence_example : Example_types.sequence_example -> Pbrt.Encoder.t -> unit
(** [encode_sequence_example v encoder] encodes [v] with the given [encoder] *)


(** {2 Protobuf Decoding} *)

val decode_example : Pbrt.Decoder.t -> Example_types.example
(** [decode_example decoder] decodes a [example] value from [decoder] *)

val decode_sequence_example : Pbrt.Decoder.t -> Example_types.sequence_example
(** [decode_sequence_example decoder] decodes a [sequence_example] value from [decoder] *)
