# ocaml-tensorboard

The __ocaml-tensorboard__ library provides functions to write TensorBoard
events from ocaml without relying on TensorFlow.
[TensorBoard](https://www.tensorflow.org/how_tos/summaries_and_tensorboard/)
is a collection of web applications that makes it easy to visualize and understand
what happens during the training of a TensorFlow based model.
TensorBoard events are logged for some specified step (which is an increasing integer)
and can embed scalars, text, images, histograms...

Installation can be made via opam.
```
opam install tensorboard
```

Here is an example of code writing some TensorBoard values.
```ocaml
module Sw = Tensorboard.Summary_writer

let sw = Sw.create "/tmp/tensorboard-logs" in
Sw.write_value sw ~step:14 ~name:"value/3" ~value:42.0;
Sw.write_text sw ~step:28 ~name:"txt" ~text:"foobar";
Sw.close sw
```

Part of the code comes from [ocaml-protoc](https://github.com/mransan/ocaml-protoc) and
[ppx_deriving_protobuf](https://github.com/ocaml-ppx/ppx_deriving_protobuf).
