(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9a-fA-F]){8}$
(assert (not (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}")))))
; sql.*badurl\x2Egrandstreetinteractive\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "sql") (re.* re.allchar) (str.to_re "badurl.grandstreetinteractive.com\u{0a}")))))
; ^\s*
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ^((0[1-9])|(1[0-2]))\/((0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))\/(\d{4})$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(([1-9]{1})|([0-1][1-2])|(0[1-9])|([1][0-2])):([0-5][0-9])(([aA])|([pP]))[mM]$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ (re.range "0" "1") (re.range "1" "2")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":") (re.union (str.to_re "a") (str.to_re "A") (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
(assert (> (str.len X) 10))
(check-sat)
