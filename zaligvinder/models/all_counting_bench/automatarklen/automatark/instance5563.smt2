(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[5,6]\d{7}|^$
(assert (not (str.in_re X (re.union (re.++ (re.union (str.to_re "5") (str.to_re ",") (str.to_re "6")) ((_ re.loop 7 7) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
