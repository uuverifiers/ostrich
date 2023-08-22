(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Eweepee\x2Ecom\w+Owner\x3Aiswww\x2Eemp3finder\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "www.weepee.com\u{1b}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:iswww.emp3finder.com\u{0a}"))))
; httphost[^\n\r]*www\x2Emaxifiles\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "httphost") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "www.maxifiles.com\u{0a}")))))
; ^(\+?420)? ?[0-9]{3} ?[0-9]{3} ?[0-9]{3}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (str.to_re "420"))) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Pleasewww\x2Ewebfringe\x2Ecom\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furax
(assert (str.in_re X (str.to_re "Pleasewww.webfringe.com\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furax\u{0a}")))
; ((IT|LV)-?)?[0-9]{11}
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "IT") (str.to_re "LV")) (re.opt (str.to_re "-")))) ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
