(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((\+{1})|(0{2}))98|(0{1}))9[1-9]{1}\d{8}\Z$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union ((_ re.loop 1 1) (str.to_re "+")) ((_ re.loop 2 2) (str.to_re "0"))) (str.to_re "98")) ((_ re.loop 1 1) (str.to_re "0"))) (str.to_re "9") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; [\u{80}-\xFF]
(assert (str.in_re X (re.++ (re.range "\u{80}" "\u{ff}") (str.to_re "\u{0a}"))))
; (?i)^((((0[1-9])|([12][0-9])|(3[01])) ((JAN)|(MAR)|(MAY)|(JUL)|(AUG)|(OCT)|(DEC)))|((((0[1-9])|([12][0-9])|(30)) ((APR)|(JUN)|(SEP)|(NOV)))|(((0[1-9])|([12][0-9])) FEB))) \d\d\d\d ((([0-1][0-9])|(2[0-3])):[0-5][0-9]:[0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re " ") (re.union (str.to_re "JAN") (str.to_re "MAR") (str.to_re "MAY") (str.to_re "JUL") (str.to_re "AUG") (str.to_re "OCT") (str.to_re "DEC"))) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (str.to_re "30")) (str.to_re " ") (re.union (str.to_re "APR") (str.to_re "JUN") (str.to_re "SEP") (str.to_re "NOV"))) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9"))) (str.to_re " FEB"))) (str.to_re " ") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (str.to_re " \u{0a}") (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))
; /[0-9a-fA-F]{8}[a-z]{6}.php/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) ((_ re.loop 6 6) (re.range "a" "z")) re.allchar (str.to_re "php/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
