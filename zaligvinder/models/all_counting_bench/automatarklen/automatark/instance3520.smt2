(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(49030)[2-9](\d{10}$|\d{12,13}$))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}49030") (re.range "2" "9") (re.union ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 12 13) (re.range "0" "9"))))))
; IPUSER-Host\x3AUser-Agent\x3A\x2Fsearchfast\x2F
(assert (str.in_re X (str.to_re "IPUSER-Host:User-Agent:/searchfast/\u{0a}")))
; \u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (str.in_re X (str.to_re "(robert@blackcastlesoft.com)\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
