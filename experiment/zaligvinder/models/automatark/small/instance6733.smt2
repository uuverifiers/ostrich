(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [^A-Za-z0-9]
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (str.to_re "\u{0a}"))))
; whenu\x2Ecom\d+Agent\stoWebupdate\.cgithisHost\u{3a}connection
(assert (not (str.in_re X (re.++ (str.to_re "whenu.com\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "Agent") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toWebupdate.cgithisHost:connection\u{0a}")))))
; [A-Za-z]{2}[0-9]{1,6}|[0-9]{1,8}
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ ((_ re.loop 1 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^([GB])*(([1-9]\d{8})|([1-9]\d{11}))$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "G") (str.to_re "B"))) (re.union (re.++ (re.range "1" "9") ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 11 11) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)
