(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((EE|EL|DE|PT)-?)?[0-9]{9}
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "EE") (str.to_re "EL") (str.to_re "DE") (str.to_re "PT")) (re.opt (str.to_re "-")))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[01]?[- .]?\(?[2-9]\d{2}\)?[- .]?\d{3}[- .]?\d{4}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) (re.opt (str.to_re "(")) (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{13}\u{28}\x0A\u{51}/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 13 13) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "(\u{0a}Q/\u{0a}"))))
(check-sat)
