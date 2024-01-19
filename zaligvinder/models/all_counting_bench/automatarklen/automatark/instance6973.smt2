(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; cdpView.*protocol.*\x2Fs\u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (not (str.in_re X (re.++ (str.to_re "cdpView") (re.* re.allchar) (str.to_re "protocol") (re.* re.allchar) (str.to_re "/s(robert@blackcastlesoft.com)\u{0a}")))))
; ^[A-z]?\d{8}[A-z]$
(assert (not (str.in_re X (re.++ (re.opt (re.range "A" "z")) ((_ re.loop 8 8) (re.range "0" "9")) (re.range "A" "z") (str.to_re "\u{0a}")))))
; ^[a-zA-Z0-9]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^(0[1-9]|1[0-2])\/((0[1-9]|2\d)|3[0-1])\/(19\d\d|200[0-3])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "2") (re.range "0" "9"))) (str.to_re "/") (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "200") (re.range "0" "3"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
