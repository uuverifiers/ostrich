(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[a-z]{5,8}\d{2,3}\.jar\u{0d}\u{0a}/Hm
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".jar\u{0d}\u{0a}/Hm\u{0a}")))))
(check-sat)
