(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^[A-Z]{1,3}\d{6}$
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "A" "Z")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3A\ssource%3Dultrasearch136%26campaign%3Dsnap
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "source%3Dultrasearch136%26campaign%3Dsnap\u{0a}"))))
; couponbar\.coupons\.com\dOwner\x3AX-Sender\x3A
(assert (str.in_re X (re.++ (str.to_re "couponbar.coupons.com") (re.range "0" "9") (str.to_re "Owner:X-Sender:\u{13}\u{0a}"))))
; \.icosearch\u{2e}conduit\u{2e}com\x3Clogs\u{40}logs\x2Ecom\x3E
(assert (str.in_re X (str.to_re ".icosearch.conduit.com<logs@logs.com>\u{0a}")))
(check-sat)
