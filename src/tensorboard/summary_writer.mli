type t
val create : string -> t
val close : t -> unit
val write_value : t -> step:int -> name:string -> value:float -> unit
