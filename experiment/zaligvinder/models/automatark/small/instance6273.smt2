(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; MSNLOGOVNUsertooffers\x2Ebullseye-network\x2Ecom
(assert (str.in_re X (str.to_re "MSNLOGOVNUsertooffers.bullseye-network.com\u{0a}")))
; ^[A-Za-z]{2}[0-9]{6}[A-Za-z]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
; FTP.*www\x2Ewordiq\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "FTP") (re.* re.allchar) (str.to_re "www.wordiq.com\u{1b}\u{0a}"))))
; this\w+c\.goclick\.com\d
(assert (str.in_re X (re.++ (str.to_re "this") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "c.goclick.com") (re.range "0" "9") (str.to_re "\u{0a}"))))
(check-sat)
