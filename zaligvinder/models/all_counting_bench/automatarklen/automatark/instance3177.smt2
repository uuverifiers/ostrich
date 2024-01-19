(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; stats\u{2e}drivecleaner\u{2e}comExciteasdbiz\x2Ebiz
(assert (not (str.in_re X (str.to_re "stats.drivecleaner.com\u{13}Exciteasdbiz.biz\u{0a}"))))
; UI2ftpquickbrutehttp\x3A\x2F\x2Fdiscounts\x2Eshopathome\x2Ecom\x2Fframeset\x2Easp\?
(assert (str.in_re X (str.to_re "UI2ftpquickbrutehttp://discounts.shopathome.com/frameset.asp?\u{0a}")))
; snprtz\x7Cdialnoref\x3D\u{25}user\x5FidPG=SPEEDBAR
(assert (str.in_re X (str.to_re "snprtz|dialnoref=%user_idPG=SPEEDBAR\u{0a}")))
; \d{5}\-\d{3}
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\x3A\s+cyber@yahoo\x2Ecom\sWordSpy\-LockedURLBlaze
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "cyber@yahoo.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "WordSpy-LockedURLBlaze\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
