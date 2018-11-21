(** feature.proto Binary Encoding *)


(** {2 Protobuf Encoding} *)

val encode_bytes_list : Feature_types.bytes_list -> Pbrt.Encoder.t -> unit
(** [encode_bytes_list v encoder] encodes [v] with the given [encoder] *)

val encode_float_list : Feature_types.float_list -> Pbrt.Encoder.t -> unit
(** [encode_float_list v encoder] encodes [v] with the given [encoder] *)

val encode_int64_list : Feature_types.int64_list -> Pbrt.Encoder.t -> unit
(** [encode_int64_list v encoder] encodes [v] with the given [encoder] *)

val encode_feature : Feature_types.feature -> Pbrt.Encoder.t -> unit
(** [encode_feature v encoder] encodes [v] with the given [encoder] *)

val encode_features : Feature_types.features -> Pbrt.Encoder.t -> unit
(** [encode_features v encoder] encodes [v] with the given [encoder] *)

val encode_feature_list : Feature_types.feature_list -> Pbrt.Encoder.t -> unit
(** [encode_feature_list v encoder] encodes [v] with the given [encoder] *)

val encode_feature_lists : Feature_types.feature_lists -> Pbrt.Encoder.t -> unit
(** [encode_feature_lists v encoder] encodes [v] with the given [encoder] *)


(** {2 Protobuf Decoding} *)

val decode_bytes_list : Pbrt.Decoder.t -> Feature_types.bytes_list
(** [decode_bytes_list decoder] decodes a [bytes_list] value from [decoder] *)

val decode_float_list : Pbrt.Decoder.t -> Feature_types.float_list
(** [decode_float_list decoder] decodes a [float_list] value from [decoder] *)

val decode_int64_list : Pbrt.Decoder.t -> Feature_types.int64_list
(** [decode_int64_list decoder] decodes a [int64_list] value from [decoder] *)

val decode_feature : Pbrt.Decoder.t -> Feature_types.feature
(** [decode_feature decoder] decodes a [feature] value from [decoder] *)

val decode_features : Pbrt.Decoder.t -> Feature_types.features
(** [decode_features decoder] decodes a [features] value from [decoder] *)

val decode_feature_list : Pbrt.Decoder.t -> Feature_types.feature_list
(** [decode_feature_list decoder] decodes a [feature_list] value from [decoder] *)

val decode_feature_lists : Pbrt.Decoder.t -> Feature_types.feature_lists
(** [decode_feature_lists decoder] decodes a [feature_lists] value from [decoder] *)
