(set-option :produce-models true)
(set-option :inline-size-limit 10000)

(declare-const var0 String)
(declare-const y String)
(assert (= var0 "abb"))
(assert (= y
          ((_ str.extract 1) var0 (re.+ ((_ re.capture 1) (re.*? re.allchar))))))
(assert (= y "b"))

(check-sat)
(get-model)
