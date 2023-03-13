(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}asf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".asf/i\u{0a}"))))
; SurveillanceacezHost\x3Acouponbar\.coupons\.comLOG
(assert (str.in_re X (str.to_re "Surveillance\u{13}acezHost:couponbar.coupons.comLOG\u{0a}")))
; (^\*\.[a-zA-Z][a-zA-Z][a-zA-Z]$)|(^\*\.\*$)
(assert (not (str.in_re X (re.union (re.++ (str.to_re "*.") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.union (re.range "a" "z") (re.range "A" "Z")) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "*.*\u{0a}")))))
; (^[0-9]{0,10}$)
(assert (str.in_re X (re.++ ((_ re.loop 0 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
