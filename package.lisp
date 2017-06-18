(defpackage #:tensorflow
  (:nicknames #:tf)
  (:use #:cl)
  (:export "CHECK-STATUS" "WITH-SESSION-OPTIONS" "WITH-SESSION" 
	   "WITH-TENSOR" "WITH-GRAPH" "WITH-BUFFER"
	   "FILE-AS-BYTES" "LOAD-GRAPH-DEF" "CREATE-GRAPH"
	   "VERSION" "LIST-OPERATIONS"))

(defpackage #:tensorflow.ffi
  (:use)
  (:nicknames #:tf.ffi))

(defpackage #:tensorflow.protobuf
  (:use)
  (:nicknames #:tf.pb))

(defpackage #:tensorflow.test
  (:use #:cl #:tensorflow)
  (:export "RUN"))
