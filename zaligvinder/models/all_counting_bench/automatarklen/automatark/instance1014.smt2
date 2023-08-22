(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Ephp\s+www\x2Ewebfringe\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re ".php") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.webfringe.com\u{0a}")))))
; ^\(?\+([9]{2}?[6])\)?[-. ]?([0-9]{3})[-. ]?([0-9]{3})[-. ]?([0-9]{3})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "(")) (str.to_re "+") (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}") ((_ re.loop 2 2) (str.to_re "9")) (str.to_re "6")))))
; LOG\s+spyblpatHost\x3Ais\x2Ephp
(assert (str.in_re X (re.++ (str.to_re "LOG") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblpatHost:is.php\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
