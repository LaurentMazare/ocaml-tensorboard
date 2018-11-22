open Base
open Tensorboard

let%expect_test _ =
  let filename = Caml.Filename.temp_file "tf-" ".pb" in
  let writer = Tf_record_writer.create ~filename in
  let pi =
    List.map [ 3; 1; 4; 1; 5; 9; 2; 6; 5; 3; 5; 8; 9; 7; 9 ] ~f:Int64.of_int
  in
  Tf_record_writer.write_example writer
    [ "test", `f [ 42.; 1.337 ]
    ; "pi", `i pi
    ; "pi2", `i [ Int64.of_int 314159265358979 ]
    ];
  Tf_record_writer.write_example writer
    [ "test", `f [ 0.; 1.; 1.5 ]
    ];
  Tf_record_writer.close writer;
  assert (0 = Caml.Sys.command (Printf.sprintf "cat %s | md5sum" filename));
  [%expect{|
        96753fb8abbcf786540d0aef5ffbfd3b  -
      |}];
  Unix.unlink filename
