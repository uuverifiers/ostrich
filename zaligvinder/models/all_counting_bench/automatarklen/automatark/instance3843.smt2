(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]{1,2}[1-9][0-9]?[A-Z]? [0-9][A-Z]{2,}|GIR 0AA$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "1" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "A" "Z")) (str.to_re " ") (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")) (re.* (re.range "A" "Z"))) (str.to_re "GIR 0AA\u{0a}")))))
; (SE-?)?[0-9]{12}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "SE") (re.opt (str.to_re "-")))) ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([0-1][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])([Z]|\.[0-9]{4}|[-|\+]([0-1][0-9]|2[0-3]):([0-5][0-9]))?$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::") (re.opt (re.union (str.to_re "Z") (re.++ (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (str.to_re "-") (str.to_re "|") (str.to_re "+")) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9")))) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9")))))
; ^([a-zA-Z ';-]+)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re " ") (str.to_re "'") (str.to_re ";") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; (?i)^((((0[1-9])|([12][0-9])|(3[01])) ((JAN)|(MAR)|(MAY)|(JUL)|(AUG)|(OCT)|(DEC)))|((((0[1-9])|([12][0-9])|(30)) ((APR)|(JUN)|(SEP)|(NOV)))|(((0[1-9])|([12][0-9])) FEB))) \d\d\d\d ((([0-1][0-9])|(2[0-3])):[0-5][0-9]:[0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re " ") (re.union (str.to_re "JAN") (str.to_re "MAR") (str.to_re "MAY") (str.to_re "JUL") (str.to_re "AUG") (str.to_re "OCT") (str.to_re "DEC"))) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (str.to_re "30")) (str.to_re " ") (re.union (str.to_re "APR") (str.to_re "JUN") (str.to_re "SEP") (str.to_re "NOV"))) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9"))) (str.to_re " FEB"))) (str.to_re " ") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (str.to_re " \u{0a}") (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))
(assert (> (str.len X) 10))
(check-sat)
