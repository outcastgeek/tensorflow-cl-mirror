(in-package :tf.ffi)

(cl:defmethod cl:print-object ((self tf-operation) stream)
  (cl:print-unreadable-object (self stream :type cl:t :identity cl:t)
    (cl:format stream "~A" (tf-operation-name self))))

(cl:defmethod cl:print-object ((self tf-tensor) stream)
  (cl:print-unreadable-object (self stream :type cl:t :identity cl:t)
    (cl:format stream "~{~A~^ ~}" (cl:loop :for d :below (tf-num-dims self)
				       :collect (tf-dim self d)))))

(cl:defmethod cl:print-object ((self tf-input) stream)
  (cl:print-unreadable-object (self stream :type cl:t :identity cl:t)
    (cl:format stream "~A:~A" (tf-operation-name (tf-input.oper self)) (tf-input.index self))))

(cl:defmethod cl:print-object ((self tf-output) stream)
  (cl:print-unreadable-object (self stream :type cl:t :identity cl:t)
    (cl:format stream "~A:~A" (tf-operation-name (tf-output.oper self)) (tf-output.index self))))

