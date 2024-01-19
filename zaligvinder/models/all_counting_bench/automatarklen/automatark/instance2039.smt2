(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\+)?([-\._\(\) ]?[\d]{3,20}[-\._\(\) ]?){2,10}
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 10) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re " "))) ((_ re.loop 3 20) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re " "))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
