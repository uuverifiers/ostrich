(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/f\/1\d{9}\/\d{9,10}(\/\d)+$/U
(assert (not (str.in_re X (re.++ (str.to_re "//f/1") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 9 10) (re.range "0" "9")) (re.+ (re.++ (str.to_re "/") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
