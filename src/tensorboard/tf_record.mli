type t
val create : filename:string -> t
val close : t -> unit
val write : t -> string -> unit
