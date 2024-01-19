(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{2,3}|\(\d{2,3}\))?[ ]?\d{3,4}[-]?\d{3,4}$
(assert (not (str.in_re X (re.++ (re.opt (re.union ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (str.to_re "(") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ")")))) (re.opt (str.to_re " ")) ((_ re.loop 3 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
