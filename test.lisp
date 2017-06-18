(in-package :tensorflow.test)

;; (defvar *xgboost-path* (merge-pathnames "xgboost/" (user-homedir-pathname)))

(defun almost-equal (a b &optional (epsilon 1e6))
  (if (and (listp a) (listp b))
      (every #'identity (mapcar #'almost-equal a b))
      (if (and (numberp a) (numberp b))
	  (< (/ (- a b) (+ a b)) epsilon)
	  (equal a b))))

(defun run ()
  (5am:run! 'tensorflow-suite))

(5am:def-suite tensorflow-suite)

(5am:in-suite tensorflow-suite)

(5am:test version
  (5am:is (almost-equal (version) "1.2.0")))

(5am:test list-operations
  (5am:is (almost-equal (first (list-operations)) "Abort")))
