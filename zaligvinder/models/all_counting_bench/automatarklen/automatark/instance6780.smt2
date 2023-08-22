(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; TPSystem\s+TencentTraveler\s+www\u{2e}urlblaze\u{2e}netCurrentHost\x3AWindows
(assert (not (str.in_re X (re.++ (str.to_re "TPSystem") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TencentTraveler") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.urlblaze.netCurrentHost:Windows\u{0a}")))))
; ^(27|0)[0-9]{9}
(assert (str.in_re X (re.++ (re.union (str.to_re "27") (str.to_re "0")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
