(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(97(8|9))?\d{9}(\d|X)$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "97") (re.union (str.to_re "8") (str.to_re "9")))) ((_ re.loop 9 9) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "X")) (str.to_re "\u{0a}"))))
(check-sat)
