(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(\d+)$)|(^(\d{1,3}[ ,\.](\d{3}[ ,\.])*\d{3}|\d{1,3})$)
(assert (not (str.in_re X (re.union (re.+ (re.range "0" "9")) (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re ",") (str.to_re ".")) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re ",") (str.to_re ".")))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}"))))))
; (\+)?([-\._\(\) ]?[\d]{3,20}[-\._\(\) ]?){2,10}
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 10) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re " "))) ((_ re.loop 3 20) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re " "))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
