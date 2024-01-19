(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0?[1-9]|1[012])(:[0-5]\d){1,2}(\ [AaPp][Mm]))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) ((_ re.loop 1 2) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (str.to_re " ") (re.union (str.to_re "A") (str.to_re "a") (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "M") (str.to_re "m"))))))
(assert (> (str.len X) 10))
(check-sat)
