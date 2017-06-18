(in-package :tensorflow)

(defun decode-status (status)
  (cons (elt '(:OK
	       :CANCELLED
	       :UNKNOWN
	       :INVALID-ARGUMENT
	       :DEADLINE-EXCEEDED
	       :NOT-FOUND
	       :ALREADY-EXISTS
	       :PERMISSION-DENIED
	       :RESOURCE-EXHAUSTED
	       :FAILED-PRECONDITION
	       :ABORTED
	       :OUT-OF-RANGE
	       :UNIMPLEMENTED
	       :INTERNAL
	       :UNAVAILABLE
	       :DATA-LOSS
	       :UNAUTHENTICATED)
	     (tf.ffi:tf-get-code status))
	(tf.ffi:tf-message status)))

(defmacro check-status (tf-call)
  (let ((status-var (gensym "STATUS")))
    `(let ((,status-var (tf.ffi:tf-new-status)))
       (unwind-protect 
	    (let* ((output ,(append tf-call (list status-var)))
		   (status (decode-status ,status-var)))
	      (if (eq :ok (car status))
		  output
		  (error "~A ~A" (car status) (cdr status))))
	 (tf.ffi:tf-delete-status ,status-var)))))

(defmacro with-tensor ((var tensor) &body body)
  `(let ((,var ,tensor))
     (unwind-protect
	  (progn ,@body)
       (tf.ffi:tf-delete-tensor ,var))))

(defmacro with-graph ((var graph) &body body)
  `(let ((,var ,graph))
     (unwind-protect
	  (progn ,@body)
       (tf.ffi:tf-delete-graph ,var))))

(defmacro with-buffer ((var bytes) &body body)
  `(let ((,var (tf.ffi:tf-new-buffer)))
     (unwind-protect
	  (progn
	    (cffi:with-foreign-object (def :unsigned-char (length ,bytes))
	      (loop for x across ,bytes for i from 0
		 do (setf (cffi:mem-aref def :unsigned-char i) x))
	      (setf (tf.ffi:tf-buffer.length ,var) (length ,bytes)
		    (tf.ffi:tf-buffer.data ,var) def))
	    ,@body)
       (tf.ffi:tf-delete-buffer ,var))))

(defmacro with-session-options ((var &optional options) &body body)
  (when options (error "can't handle session options yet"))
  `(let ((,var (tf.ffi:tf-new-session-options)))
     (unwind-protect
	  (progn ,@body)
       (tf.ffi:tf-delete-session-options ,var))))

(defmacro with-session ((var graph &optional options) &body body)
  (let ((options-var (gensym "OPTIONS")))
    `(let ((,var (with-session-options (,options-var)
		   (check-status (tf.ffi:tf-new-session ,graph ,options-var)))))
       (unwind-protect
	    (progn ,@body)
	 (progn
	   (check-status (tf.ffi:tf-close-session ,var))
	   (check-status (tf.ffi:tf-delete-session ,var)))))))

(defun version () (tf.ffi:tf-version))

(defun get-foreign-sequence (pointer size)
  (let ((res (make-array size :element-type '(unsigned-byte 8))))
    (loop for i below size
       do (setf (aref res i) (cffi:mem-aref pointer :unsigned-char i)))
    res))

(defun list-operations ()
  (let* ((ops (tf.ffi:tf-get-all-op-list))
	 (size (tf.ffi:tf-buffer.length ops))
	 (data (tf.ffi:tf-buffer.data ops)))
    (let ((op-list (make-instance 'tf.pb:op-list)))
      (pb:merge-from-array op-list
			   (get-foreign-sequence data size)
			   0 size)
      (sort (loop for op across (tf.pb:op op-list) collect (protocol-buffer:string-value (tf.pb:name op)))
	    #'string<))))

;; (list-operations)

(defun file-as-bytes (path)
  (with-open-file (s path :element-type 'unsigned-byte)
    (let ((buf (make-array (file-length s) :element-type '(unsigned-byte 8))))
      (read-sequence buf s)
      buf)))

(defun load-graph-def (bytes)
  (let ((graph-def (make-instance 'tf.pb:graph-def)))
    (pb:merge-from-array graph-def bytes 0 (length raw))
    graph-def))

(defun create-graph (bytes)
  (with-buffer (tfbuf bytes)
    (let ((graph (tf.ffi:tf-new-graph)))
      (check-status (tf.ffi::tf-graph-import-graph-def 
		     graph tfbuf (tf.ffi::tf-new-import-graph-def-options)))
      graph)))
