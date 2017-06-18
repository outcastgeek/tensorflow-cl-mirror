(in-package #:asdf)

;; cp ~/tensorflow/tensorflow/core/framework/*.proto ~/lisp/tensorflow/proto
;;   change the package tensorflow; line to package tensorflow.protobuf;
;;   and change the import statments, when included, to remove the path
;;   load this system once to generate the corresponding lisp files
;; (load "/Users/ungil/quicklisp/local-projects/tensorflow/tensorflow.asd")
;; (asdf:load-system :tensorflow/protobuf :force t)
;;   copy these output files into the proto directory
;; cp ~/.cache/common-lisp/sbcl-1.3.18-macosx-x64/Users/ungil/lisp/tensorflow/proto/*lisp ~/lisp/tensorflow/proto

(defsystem #:tensorflow/protobuf
  :defsystem-depends-on (protobuf)
  :serial t
  :components ((:protobuf-source-file "proto/types")
	       (:protobuf-source-file "proto/resource_handle")
	       (:protobuf-source-file "proto/tensor_shape")
	       (:protobuf-source-file "proto/tensor")
	       (:protobuf-source-file "proto/attr_value")
	       (:protobuf-source-file "proto/op_def")
	       (:protobuf-source-file "proto/node_def")
	       (:protobuf-source-file "proto/function")
	       (:protobuf-source-file "proto/versions")
	       (:protobuf-source-file "proto/graph")))

(defsystem #:tensorflow
    :name "tensorflow"
    :author "Carlos Ungil <ungil@mac.com>"
    :license "Apache License, Version 2.0"
    :description "Common Lisp interface to http://tensorflow.org"
    :in-order-to ((test-op (test-op "tensorflow/test")))
    :depends-on (:trivial-garbage :cffi :cl-autowrap :alexandria :protobuf)
    :serial t
    :components ((:module #:ffi :pathname "ffi" :components ((:static-file "c_api.h")))
		 (:file "package")
		 (:file "wrapper")
		 (:file "proto/types")
		 (:file "proto/resource_handle")
		 (:file "proto/tensor_shape")
		 (:file "proto/tensor")
		 (:file "proto/attr_value")
		 (:file "proto/op_def")
		 (:file "proto/node_def")
		 (:file "proto/function")
		 (:file "proto/versions")
		 (:file "proto/graph")
		 (:file "pb-printers")
		 (:file "ffi-printers")
		 (:file "tensorflow")))

(defsystem #:tensorflow/test
    :name "tensorflow test suite"
    :author "Carlos Ungil <ungil@mac.com>"
    :license "Apache License, Version 2.0"
    :depends-on (:tensorflow :fiveam)
    :components ((:file "test"))
    :perform (asdf:test-op (o s) (uiop:symbol-call :tensorflow.test '#:run)))
