(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((\(\d{2}\) ?)|(\d{2}/))?\d{2}/\d{4} ([0-2][0-9]\:[0-6][0-9])
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/")))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " \u{0a}") (re.range "0" "2") (re.range "0" "9") (str.to_re ":") (re.range "0" "6") (re.range "0" "9")))))
; cdpView.*protocol.*\x2Fs\u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (str.in_re X (re.++ (str.to_re "cdpView") (re.* re.allchar) (str.to_re "protocol") (re.* re.allchar) (str.to_re "/s(robert@blackcastlesoft.com)\u{0a}"))))
(check-sat)
