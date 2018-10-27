open Tensorboard

let () =
  let summary_writer = Summary_writer.create "/tmp/logs2/test.tfevents" in
  for step = 0 to 42 do
    let value = Float.of_int step |> Float.cos in
    Summary_writer.write_value summary_writer ~step ~name:"value" ~value;
  done;
  Summary_writer.close summary_writer
