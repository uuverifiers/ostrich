(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}htc([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.htc") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; SurveillanceacezHost\x3Acouponbar\.coupons\.comLOG
(assert (not (str.in_re X (str.to_re "Surveillance\u{13}acezHost:couponbar.coupons.comLOG\u{0a}"))))
; /^\/[a-f0-9]{32}\.php\?q=[a-f0-9]{32}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".php?q=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
(check-sat)
