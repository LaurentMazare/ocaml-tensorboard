(** feature.proto Types *)



(** {2 Types} *)

type bytes_list = {
  value : bytes list;
}

type float_list = {
  value : float list;
}

type int64_list = {
  value : int64 list;
}

type feature =
  | Bytes_list of bytes_list
  | Float_list of float_list
  | Int64_list of int64_list

type features = {
  feature : (string * feature) list;
}

type feature_list = {
  feature : feature list;
}

type feature_lists = {
  feature_list : (string * feature_list) list;
}


(** {2 Default values} *)

val default_bytes_list : 
  ?value:bytes list ->
  unit ->
  bytes_list
(** [default_bytes_list ()] is the default value for type [bytes_list] *)

val default_float_list : 
  ?value:float list ->
  unit ->
  float_list
(** [default_float_list ()] is the default value for type [float_list] *)

val default_int64_list : 
  ?value:int64 list ->
  unit ->
  int64_list
(** [default_int64_list ()] is the default value for type [int64_list] *)

val default_feature : unit -> feature
(** [default_feature ()] is the default value for type [feature] *)

val default_features : 
  ?feature:(string * feature) list ->
  unit ->
  features
(** [default_features ()] is the default value for type [features] *)

val default_feature_list : 
  ?feature:feature list ->
  unit ->
  feature_list
(** [default_feature_list ()] is the default value for type [feature_list] *)

val default_feature_lists : 
  ?feature_list:(string * feature_list) list ->
  unit ->
  feature_lists
(** [default_feature_lists ()] is the default value for type [feature_lists] *)
