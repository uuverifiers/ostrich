(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([L|U]{1})([0-9]{5})([A-Za-z]{2})([0-9]{4})([A-Za-z]{3})([0-9]{6})$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "L") (str.to_re "|") (str.to_re "U"))) ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
