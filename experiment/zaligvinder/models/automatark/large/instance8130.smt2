(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d(\u{20})\d{2}(\u{20})\d{2}(\u{20})\d{2}(\u{20})\d{3}(\u{20})\d{3}((\u{20})\d{2}|))|(\d\d{2}\d{2}\d{2}\d{3}\d{3}(\d{2}|)))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.range "0" "9") (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^([A-z]{2}\d{9}[Gg][Bb])|(\d{12})$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "z")) ((_ re.loop 9 9) (re.range "0" "9")) (re.union (str.to_re "G") (str.to_re "g")) (re.union (str.to_re "B") (str.to_re "b"))) (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\x3A.*c=[^\n\r]*KeyloggerHost\x3Awww\.trackhits\.cc
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "c=") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "KeyloggerHost:www.trackhits.cc\u{0a}"))))
; ^[A-Z]{2,4}[0-9][A-Z0-9]+$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 4) (re.range "A" "Z")) (re.range "0" "9") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
