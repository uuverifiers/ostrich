(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{2,3}-? ?[0-9]{6,7}$
(assert (str.in_re X (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
