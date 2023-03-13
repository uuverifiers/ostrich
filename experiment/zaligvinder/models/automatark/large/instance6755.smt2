(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}[A-F0-9]{158}/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 158 158) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
(check-sat)
