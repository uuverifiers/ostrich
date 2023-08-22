(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((\d{2})|(\d))\/((\d{2})|(\d))\/((\d{4})|(\d{2}))
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.range "0" "9")) (str.to_re "/") (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.range "0" "9")) (str.to_re "/") (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; from\s+\x2Fdss\x2Fcc\.2_0_0\.[^\n\r]*uploadServer
(assert (not (str.in_re X (re.++ (str.to_re "from") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/dss/cc.2_0_0.") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "uploadServer\u{0a}")))))
; \u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (str.in_re X (str.to_re "(robert@blackcastlesoft.com)\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
