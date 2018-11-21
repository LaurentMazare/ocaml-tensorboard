(** example.proto Types *)



(** {2 Types} *)

type example = {
  features : Feature_types.features option;
}

type sequence_example = {
  context : Feature_types.features option;
  feature_lists : Feature_types.feature_lists option;
}


(** {2 Default values} *)

val default_example : 
  ?features:Feature_types.features option ->
  unit ->
  example
(** [default_example ()] is the default value for type [example] *)

val default_sequence_example : 
  ?context:Feature_types.features option ->
  ?feature_lists:Feature_types.feature_lists option ->
  unit ->
  sequence_example
(** [default_sequence_example ()] is the default value for type [sequence_example] *)
