(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(000-)(\\d{5}-){2}\\d{3}$
(assert (not (str.in_re X (re.++ (str.to_re "000-") ((_ re.loop 2 2) (re.++ (str.to_re "\u{5c}") ((_ re.loop 5 5) (str.to_re "d")) (str.to_re "-"))) (str.to_re "\u{5c}") ((_ re.loop 3 3) (str.to_re "d")) (str.to_re "\u{0a}")))))
(check-sat)
