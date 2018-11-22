module P = Tensorboard_protobuf

type t
val create : filename:string -> t
val close : t -> unit
val write : t -> string -> unit

type feature = [ `f of float list | `b of bytes list | `i of Int64.t list ]

val write_example : t -> (string * feature) list -> unit

val write_sequence_example
  :  t
  -> context:(string * feature) list
  -> feature_lists:(string * feature list) list
  -> unit
