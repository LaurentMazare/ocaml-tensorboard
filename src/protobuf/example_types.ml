[@@@ocaml.warning "-27-30-39"]


type example = {
  features : Feature_types.features option;
}

type sequence_example = {
  context : Feature_types.features option;
  feature_lists : Feature_types.feature_lists option;
}

let rec default_example 
  ?features:((features:Feature_types.features option) = None)
  () : example  = {
  features;
}

let rec default_sequence_example 
  ?context:((context:Feature_types.features option) = None)
  ?feature_lists:((feature_lists:Feature_types.feature_lists option) = None)
  () : sequence_example  = {
  context;
  feature_lists;
}
