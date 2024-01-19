(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[a-z]{2}_[a-z0-9]{8}\.mod/Ui
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "_") ((_ re.loop 8 8) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".mod/Ui\u{0a}"))))
; \u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (not (str.in_re X (str.to_re "(robert@blackcastlesoft.com)\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
