(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$
(assert (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) ((_ re.loop 3 3) (re.++ (str.to_re ".") (re.union (re.range "0" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))))) (str.to_re "\u{0a}"))))
; ^((\+989)|(989)|(00989)|(09|9))([1|2|3][0-9]\d{7}$)
(assert (not (str.in_re X (re.++ (re.union (str.to_re "+989") (str.to_re "989") (str.to_re "00989") (str.to_re "09") (str.to_re "9")) (str.to_re "\u{0a}") (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2") (str.to_re "3")) (re.range "0" "9") ((_ re.loop 7 7) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
