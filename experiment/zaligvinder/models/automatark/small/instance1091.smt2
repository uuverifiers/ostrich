(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{3,3}\.\d{0,2}$|^E\d{3,3}\.\d{0,2}$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "E") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^([V|E|J|G|v|e|j|g])([0-9]{5,8})$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "V") (str.to_re "|") (str.to_re "E") (str.to_re "J") (str.to_re "G") (str.to_re "v") (str.to_re "e") (str.to_re "j") (str.to_re "g")) ((_ re.loop 5 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
