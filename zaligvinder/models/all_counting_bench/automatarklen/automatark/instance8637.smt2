(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Days\s+HWAE\s+Host\x3APortawww\.thecommunicator\.net
(assert (not (str.in_re X (re.++ (str.to_re "Days") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HWAE") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Portawww.thecommunicator.net\u{0a}")))))
; ^([01]\d|2[0123])([0-5]\d){2}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3")))) ((_ re.loop 2 2) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; cyber@yahoo\x2Ecomconfig\x2E180solutions\x2Ecom
(assert (str.in_re X (str.to_re "cyber@yahoo.comconfig.180solutions.com\u{0a}")))
; ^-?([1-8]?[0-9]\.{1}\d{1,6}$|90\.{1}0{1,6}$)
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (re.range "1" "8")) (re.range "0" "9") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (str.to_re "90") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
