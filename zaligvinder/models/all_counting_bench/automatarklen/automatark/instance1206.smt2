(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \\s\\d{2}[-]\\w{3}-\\d{4}
(assert (str.in_re X (re.++ (str.to_re "\u{5c}s\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 3 3) (str.to_re "w")) (str.to_re "-\u{5c}") ((_ re.loop 4 4) (str.to_re "d")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
