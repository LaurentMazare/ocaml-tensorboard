[@@@ocaml.warning "-27-30-39"]


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

let rec default_bytes_list 
  ?value:((value:bytes list) = [])
  () : bytes_list  = {
  value;
}

let rec default_float_list 
  ?value:((value:float list) = [])
  () : float_list  = {
  value;
}

let rec default_int64_list 
  ?value:((value:int64 list) = [])
  () : int64_list  = {
  value;
}

let rec default_feature () : feature = Bytes_list (default_bytes_list ())

let rec default_features 
  ?feature:((feature:(string * feature) list) = [])
  () : features  = {
  feature;
}

let rec default_feature_list 
  ?feature:((feature:feature list) = [])
  () : feature_list  = {
  feature;
}

let rec default_feature_lists 
  ?feature_list:((feature_list:(string * feature_list) list) = [])
  () : feature_lists  = {
  feature_list;
}
