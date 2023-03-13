(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[a-f0-9]{135}/Um
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 135 135) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Um\u{0a}"))))
(check-sat)
