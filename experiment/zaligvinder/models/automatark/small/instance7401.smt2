(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Epurityscan\x2Ecom.*
(assert (not (str.in_re X (re.++ (str.to_re "www.purityscan.com") (re.* re.allchar) (str.to_re "\u{0a}")))))
; ^(([1-4][0-9])|(0[1-9])|(5[0-2]))\/[1-2]\d{3}$
(assert (str.in_re X (re.++ (re.union (re.++ (re.range "1" "4") (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "5") (re.range "0" "2"))) (str.to_re "/") (re.range "1" "2") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; devSoft\u{27}s\s+Host\x3A\s+Host\x3A
(assert (str.in_re X (re.++ (str.to_re "devSoft's\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
(check-sat)
