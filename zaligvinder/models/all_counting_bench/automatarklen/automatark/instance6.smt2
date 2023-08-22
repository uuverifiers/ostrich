(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0[1-9])|(1[0-2]))\/((0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))\/(\d{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (vi(v))?d
(assert (str.in_re X (re.++ (re.opt (str.to_re "viv")) (str.to_re "d\u{0a}"))))
; vvvjkhmbgnbbw\u{2f}qbn\u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (str.in_re X (str.to_re "vvvjkhmbgnbbw/qbn\u{1b}(robert@blackcastlesoft.com)\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
