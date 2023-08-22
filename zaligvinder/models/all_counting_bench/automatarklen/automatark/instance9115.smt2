(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (not (str.in_re X (str.to_re "(robert@blackcastlesoft.com)\u{0a}"))))
; ^[a-zA-Z0-9._%-]+@[a-zA-Z0-9._%-]+\.[a-zA-Z]{2,4}\s*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "%") (str.to_re "-"))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "%") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; User-Agent\x3AUser-Agent\x3AHost\u{3a}
(assert (str.in_re X (str.to_re "User-Agent:User-Agent:Host:\u{0a}")))
; \x7D\x7BOS\x3AsecurityUser-Agent\u{3a}www\x2Esogou\x2Ecom
(assert (str.in_re X (str.to_re "}{OS:securityUser-Agent:www.sogou.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
