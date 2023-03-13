(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z][a-z]+((e(m|ng)|str)a)$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "e") (re.union (str.to_re "m") (str.to_re "ng"))) (str.to_re "str")) (str.to_re "a")))))
; ^(\d{2,3}|\(\d{2,3}\))?[ ]?\d{3,4}[-]?\d{3,4}$
(assert (not (str.in_re X (re.++ (re.opt (re.union ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (str.to_re "(") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ")")))) (re.opt (str.to_re " ")) ((_ re.loop 3 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
