(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}plf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".plf/i\u{0a}"))))
; www\x2Efreescratchandwin\x2Ecom\d+Server.*www\x2Ecameup\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "www.freescratchandwin.com") (re.+ (re.range "0" "9")) (str.to_re "Server") (re.* re.allchar) (str.to_re "www.cameup.com\u{13}\u{0a}")))))
; ^([A-HJ-TP-Z]{1}\d{4}[A-Z]{3}|[a-z]{1}\d{4}[a-hj-tp-z]{3})$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "H") (re.range "J" "T") (re.range "P" "Z"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "A" "Z"))) (re.++ ((_ re.loop 1 1) (re.range "a" "z")) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "a" "h") (re.range "j" "t") (re.range "p" "z"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
