(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[-\w]{70,78}==?$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 70 78) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "=") (re.opt (str.to_re "=")) (str.to_re "/U\u{0a}"))))
(check-sat)
