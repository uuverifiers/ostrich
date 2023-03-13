(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; %3f\s+url=[^\n\r]*httpUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "%3f") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "url=") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "httpUser-Agent:\u{0a}"))))
; ^([a-zA-Z])*$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; www\x2Efreescratchandwin\x2Ecom\d+Server.*www\x2Ecameup\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "www.freescratchandwin.com") (re.+ (re.range "0" "9")) (str.to_re "Server") (re.* re.allchar) (str.to_re "www.cameup.com\u{13}\u{0a}")))))
; /^\u{2f}\u{3f}ptrxcz\u{5f}[a-zA-Z0-9]{30}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//?ptrxcz_") ((_ re.loop 30 30) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}")))))
(check-sat)
