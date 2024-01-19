(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\+?1[- .]?)?[.\(]?[\d^01]\d{2}\)?[- .]?\d{3}[- .]?\d{4}
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (str.to_re "1") (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))))) (re.opt (re.union (str.to_re ".") (str.to_re "("))) (re.union (re.range "0" "9") (str.to_re "^") (str.to_re "0") (str.to_re "1")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
