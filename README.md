# ocaml-tensorboard

The __ocaml-tensorboard__ library provides functions to write TensorBoard
events from ocaml without relying on TensorFlow.
[TensorBoard](https://www.tensorflow.org/how_tos/summaries_and_tensorboard/)
is a collection of web applications that makes it easy to visualize and understand
what happens during the training of a TensorFlow based model.
TensorBoard events are logged for some specified step (which is an increasing integer)
and can embed scalars, text, images, histograms...

```ocaml
open Tensorboard

let summary_writer = Summary_writer.create "/tmp/tensorboard-logs" in
Summary_writer.write_value summary_writer ~step:14 ~name:"value/3" ~value:42.0;
Summary_writer.write_text summary_writer ~step:28 ~name:"txt" ~text:"foobar";
Summary_writer.close summary_writer
```

Part of the code comes from [ocaml-protoc](https://github.com/mransan/ocaml-protoc) and
[ppx_deriving_protobuf](https://github.com/ocaml-ppx/ppx_deriving_protobuf).
