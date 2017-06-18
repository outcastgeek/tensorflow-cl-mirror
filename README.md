```
% sbcl --load examples/prediction.lisp

This is SBCL 1.3.18, an implementation of ANSI Common Lisp.
More information about SBCL is available at <http://www.sbcl.org/>.

SBCL is free software, provided as is, with absolutely no warranty.
It is mostly in the public domain; some portions are provided under
BSD-style licenses.  See the CREDITS and COPYING files in the
distribution for more information.
To load "tensorflow":
  Load 1 ASDF system:
    tensorflow
; Loading "tensorflow"
..................................................
[package tensorflow]..............................
[package tensorflow.ffi]..........................
[package tensorflow.protobuf].....................
[package tensorflow.test].; Note: skipping alias of type __INT32_T to __DARWIN_BLKSIZE_T due to undefined
; foreign type: __INT32_T
; Note: skipping alias of type __DARWIN_PTRDIFF_T to PTRDIFF-T due to undefined
; foreign type: __DARWIN_PTRDIFF_T
; Note: skipping alias of type __DARWIN_WCHAR_T to WCHAR-T due to undefined
; foreign type: __DARWIN_WCHAR_T
; Note: skipping alias of type __DARWIN_WINT_T to WINT-T due to undefined
; foreign type: __DARWIN_WINT_T
; Note: skipping alias of type __DARWIN_INTPTR_T to INTPTR-T due to undefined
; foreign type: __DARWIN_INTPTR_T
........................
................................; Total of 5 compile-time skipped definitions:
;   INTPTR-T PTRDIFF-T WCHAR-T WINT-T __DARWIN_BLKSIZE_T
; Total of 5 compile-time missing entities:
;   __DARWIN_INTPTR_T __DARWIN_PTRDIFF_T __DARWIN_WCHAR_T __DARWIN_WINT_T
;   __INT32_T
; Note: skipping alias of type __INT32_T to __DARWIN_BLKSIZE_T due to undefined
; foreign type: __INT32_T
; Note: skipping alias of type __DARWIN_PTRDIFF_T to PTRDIFF-T due to undefined
; foreign type: __DARWIN_PTRDIFF_T
; Note: skipping alias of type __DARWIN_WCHAR_T to WCHAR-T due to undefined
; foreign type: __DARWIN_WCHAR_T
; Note: skipping alias of type __DARWIN_WINT_T to WINT-T due to undefined
; foreign type: __DARWIN_WINT_T
; Note: skipping alias of type __DARWIN_INTPTR_T to INTPTR-T due to undefined
; foreign type: __DARWIN_INTPTR_T
; Total of 5 load-time skipped definitions:
;   INTPTR-T PTRDIFF-T WCHAR-T WINT-T __DARWIN_BLKSIZE_T
; Total of 5 load-time missing entities:
;   __DARWIN_INTPTR_T __DARWIN_PTRDIFF_T __DARWIN_WCHAR_T __DARWIN_WINT_T
;   __INT32_T
..................
..................................................
........................................
To load "opticl":
  Load 1 ASDF system:
    opticl
; Loading "opticl"

To load "drakma":
  Load 1 ASDF system:
    drakma
; Loading "drakma"
.
2017-06-19 01:37:41.788517: W tensorflow/core/platform/cpu_feature_guard.cc:45] The TensorFlow library wasn't compiled to use SSE4.2 instructions, but these are available on your machine and could speed up CPU computations.
2017-06-19 01:37:41.788712: W tensorflow/core/platform/cpu_feature_guard.cc:45] The TensorFlow library wasn't compiled to use AVX instructions, but these are available on your machine and could speed up CPU computations.
2017-06-19 01:37:41.788718: W tensorflow/core/platform/cpu_feature_guard.cc:45] The TensorFlow library wasn't compiled to use AVX2 instructions, but these are available on your machine and could speed up CPU computations.
2017-06-19 01:37:41.788721: W tensorflow/core/platform/cpu_feature_guard.cc:45] The TensorFlow library wasn't compiled to use FMA instructions, but these are available on your machine and could speed up CPU computations.

https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Blue_cup_of_coffee.svg/500px-Blue_cup_of_coffee.svg.png
(0.6316785 . soap dispenser)
(0.08330221 . candle)
(0.043023504 . vase)
(0.032329556 . eggnog)
(0.030908208 . water jug)

https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Sport_car_rim.svg/500px-Sport_car_rim.svg.png
(0.8075237 . wall clock)
(0.078929566 . magnetic compass)
(0.06762223 . analog clock)
(0.018062599 . pick)
(0.007422157 . handkerchief)

https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/PEO-car.svg/500px-PEO-car.svg.png
(0.9068225 . limousine)
(0.021388993 . cab)
(0.017623022 . racer)
(0.006476023 . minivan)
(0.0049720486 . sports car)

https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Perseus1Hfx.png/480px-Perseus1Hfx.png
(0.57681495 . aircraft carrier)
(0.14882128 . dock)
(0.049902823 . tank)
(0.027951384 . jigsaw puzzle)
(0.02609503 . crane)

https://upload.wikimedia.org/wikipedia/commons/7/77/Avatar_cat.png
(0.73312676 . tabby)
(0.14467601 . Siamese cat)
(0.059737504 . Egyptian cat)
(0.04630433 . tiger cat)
(0.012215534 . Persian cat)
```