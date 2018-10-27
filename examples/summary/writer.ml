open Tensorboard

let () =
  let summary_writer = Summary_writer.create "/tmp/logs2/test.tfevents" in
  Summary_writer.write_value summary_writer ~step:0 ~name:"value" ~value:42.0;
  Summary_writer.close summary_writer
