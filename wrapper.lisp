(cl:in-package :tensorflow.ffi)

;; https://www.tensorflow.org/install/install_c
;; https://raw.githubusercontent.com/tensorflow/tensorflow/r1.1/tensorflow/c/c_api.h

(autowrap:c-include '(tensorflow ffi "c_api.h") :spec-path '(tensorflow ffi)
		    :exclude-constants ("^_(?!.*size)")
		    :exclude-definitions ("^_(?!.*size)"))

(cffi:load-foreign-library "/usr/local/lib/libtensorflow.so")

