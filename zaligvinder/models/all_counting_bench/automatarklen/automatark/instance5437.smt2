(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; replace(MobileNo,' ',''),'^(\+44|0044|0)(7)[4-9][0-9]{8}$'
(assert (str.in_re X (re.++ (str.to_re "replaceMobileNo,' ','','") (re.union (str.to_re "+44") (str.to_re "0044") (str.to_re "0")) (str.to_re "7") (re.range "4" "9") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "'\u{0a}"))))
; [+]?[ ]?\d{1,3}[ ]?\d{1,3}[- ]?\d{4}[- ]?\d{4}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (str.to_re " ")) ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^((((0[1-9]|[1-2][0-9]|3[0-1])[./-](0[13578]|10|12))|((0[1-9]|[1-2][0-9])[./-](02))|(((0[1-9])|([1-2][0-9])|(30))[./-](0[469]|11)))[./-]((19\d{2})|(2[012]\d{2})))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (str.to_re "10") (str.to_re "12"))) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (str.to_re "02")) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (str.to_re "30")) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "0") (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "19") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")) ((_ re.loop 2 2) (re.range "0" "9")))))))
; /filename=[^\n]*\u{2e}jfi/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jfi/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
