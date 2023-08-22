(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([V|E|J|G|v|e|j|g])([0-9]{5,8})$
(assert (str.in_re X (re.++ (re.union (str.to_re "V") (str.to_re "|") (str.to_re "E") (str.to_re "J") (str.to_re "G") (str.to_re "v") (str.to_re "e") (str.to_re "j") (str.to_re "g")) ((_ re.loop 5 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
