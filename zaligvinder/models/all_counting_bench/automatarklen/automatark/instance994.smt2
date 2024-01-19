(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-zA-Z0-9]{32}\.jar/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".jar/U\u{0a}"))))
; \u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (not (str.in_re X (str.to_re "(robert@blackcastlesoft.com)\u{0a}"))))
; \u{22}reaction\x2Etxt\u{22}.*Cookie\u{3a}[^\n\r]*richfind\x2EcomSimpsonFrom\x3A
(assert (str.in_re X (re.++ (str.to_re "\u{22}reaction.txt\u{22}") (re.* re.allchar) (str.to_re "Cookie:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "richfind.comSimpsonFrom:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
