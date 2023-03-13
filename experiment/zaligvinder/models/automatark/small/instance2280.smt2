(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{2}-\d{2})*$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; encoder\s+cyber@yahoo\x2Ecomcu
(assert (str.in_re X (re.++ (str.to_re "encoder") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "cyber@yahoo.comcu\u{0a}"))))
; ^[\d]{5}[-\s]{1}[\d]{4}[-\s]{1}[\d]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; www\x2Epurityscan\x2Ecom.*
(assert (str.in_re X (re.++ (str.to_re "www.purityscan.com") (re.* re.allchar) (str.to_re "\u{0a}"))))
(check-sat)
