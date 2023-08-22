(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{1,3}$)|(\d{1,3})\.?(\d{0,0}[0,5])
(assert (str.in_re X (re.union ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re ".")) (str.to_re "\u{0a}") ((_ re.loop 0 0) (re.range "0" "9")) (re.union (str.to_re "0") (str.to_re ",") (str.to_re "5"))))))
; SbAts[^\n\r]*Subject\u{3a}\d+dcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "SbAts") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Subject:") (re.+ (re.range "0" "9")) (str.to_re "dcww.dmcast.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
