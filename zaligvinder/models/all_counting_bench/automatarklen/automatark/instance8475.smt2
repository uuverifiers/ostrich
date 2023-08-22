(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Efreescratchandwin\x2Ecom\d+Server.*www\x2Ecameup\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "www.freescratchandwin.com") (re.+ (re.range "0" "9")) (str.to_re "Server") (re.* re.allchar) (str.to_re "www.cameup.com\u{13}\u{0a}")))))
; ^((0[1-9])|(1[0-2]))\/(\d{2})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
