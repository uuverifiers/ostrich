(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z]+\?[a-z]+\=[a-z]+$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "a" "z")) (str.to_re "?") (re.+ (re.range "a" "z")) (str.to_re "=") (re.+ (re.range "a" "z")) (str.to_re "/U\u{0a}")))))
; ^([0-9]*|\d*\.\d{1}?\d*)$
(assert (str.in_re X (re.++ (re.union (re.* (re.range "0" "9")) (re.++ (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; Google\s+-~-GREATHost\u{3a}FILESIZE\x3E
(assert (str.in_re X (re.++ (str.to_re "Google") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-~-GREATHost:FILESIZE>\u{13}\u{0a}"))))
; Host\x3A\s+offers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "offers.bullseye-network.com\u{0a}")))))
; ^(\+65)?\d{8}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "+65")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
