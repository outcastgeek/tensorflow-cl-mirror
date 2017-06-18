(in-package :cl-user)

(ql:quickload :tensorflow)

(ql:quickload :opticl)

(ql:quickload :drakma)

;; wget https://storage.googleapis.com/download.tensorflow.org/models/inception5h.zip
;; and unzip the contents into ~/tensorflow-examples/

;; values have to be transformed as (value - Mean)/Scale with Mean=117 and Scale=1

;; the output has 1008 elements but there are only 1000 valid labels
;; elements with index zero (label: dummy) and 1001-1007 are ignored

(defvar *graph*
  (tf:file-as-bytes "~/tensorflow-examples/tensorflow_inception_graph.pb"))

;; (tf:load-graph-def *graph*)

(defvar *labels*
  (with-open-file (in "~/tensorflow-examples/imagenet_comp_graph_label_strings.txt")
    (loop for line = (read-line in nil nil) while line collect line)))

(defun make-tensor-from-image (channels)
  (assert (= (* 224 224 3) (reduce #'+ (mapcar #'length channels))))
  (let* ((dimensions '(1 224 224 3))
	 (size (reduce #'* dimensions)))
    (cffi:with-foreign-object (dims :int64 4)
       (loop for i from 0 below 4
	  for d in dimensions
	  do (setf (cffi:mem-aref dims :int64 i) d))
       (let* ((tensor (tf.ffi:tf-allocate-tensor tf.ffi:+tf-float+ dims (length dimensions) (* 4 size)))
	      (data (tf.ffi:tf-tensor-data tensor)))
	 (loop for i from 0 below size
	    for x in (apply #'append channels)
	    do (setf (cffi:mem-aref data :float i) (coerce x 'float)))
	 tensor))))

(defun run (channels)
  (tf:with-graph (graph (tf:create-graph *graph*))
    (tf:with-tensor (tensor (make-tensor-from-image channels))
      (tf:with-session (session graph)
	(let ((input (tf.ffi:tf-graph-operation-by-name graph "input"))
	      (output (tf.ffi:tf-graph-operation-by-name graph "output")))
	  (autowrap:with-many-alloc ((inputs 'tf.ffi:tf-output 1)
				     (outputs 'tf.ffi:tf-output 1))
	    (setf (tf.ffi:tf-output.oper (autowrap:c-aref inputs 0 'tf.ffi:tf-output)) (autowrap:ptr input)
		  (tf.ffi:tf-output.index (autowrap:c-aref inputs 0 'tf.ffi:tf-output)) 0
		  (tf.ffi:tf-output.oper (autowrap:c-aref outputs 0 'tf.ffi:tf-output)) (autowrap:ptr output)
		  (tf.ffi:tf-output.index (autowrap:c-aref outputs 0 'tf.ffi:tf-output)) 0)
	    (cffi:with-foreign-objects ((input-values :pointer) (output-values :pointer))
	      (setf (cffi:mem-aref input-values :pointer) (autowrap:ptr tensor))
	      (tf:check-status (tf.ffi:tf-session-run session nil
						      inputs input-values 1
						      outputs output-values 1
						      nil 0
						      nil))
	      (let ((res (cffi:mem-aref output-values :pointer 0)))
		(assert (= 1 (tf.ffi:tf-tensor-type res))) ;;float
		(let ((dims (loop for dim below (tf.ffi:tf-num-dims res)
			       collect (tf.ffi:tf-dim res dim))))
		  (assert (= 1 (first dims)))
		  (loop for i below (second dims)
		     collect (cffi:mem-aref (tf.ffi:tf-tensor-data res) :float i)))))))))))

(defun identify-image (png &optional (top 5) (size 224) (mean 117) (scale 1))
  (let* ((image (opticl:coerce-image
		 (opticl:resize-image (if (or (stringp png) (pathnamep png))
					  (opticl:read-png-file png)
					  (flexi-streams:with-input-from-sequence (stream png)
					    (opticl:read-png-stream stream)))
				      size size)
		 'opticl:rgb-image))
	 (channels (loop for c from 0 below 3
		      collect (loop for i from c by 3 below (array-total-size image)
				 collect (/ (- (row-major-aref image i) mean) scale)))))
    (subseq (sort (loop for prob in (run channels)
		     for label in *labels*
		     collect (cons prob label))
		  #'> :key #'car)
	    0 top)))

(defvar *test-images* '("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Blue_cup_of_coffee.svg/500px-Blue_cup_of_coffee.svg.png"
			"https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Sport_car_rim.svg/500px-Sport_car_rim.svg.png"
			"https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/PEO-car.svg/500px-PEO-car.svg.png"
			"https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Perseus1Hfx.png/480px-Perseus1Hfx.png"
			"https://upload.wikimedia.org/wikipedia/commons/7/77/Avatar_cat.png"))

(loop for url in *test-images*
   do (format t "~%~A~%~{~A~%~}" url (identify-image (drakma:http-request url))))
