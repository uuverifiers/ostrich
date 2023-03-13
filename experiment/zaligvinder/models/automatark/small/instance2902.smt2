(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; cyber@yahoo\x2Ecom\s+Host\u{3a}\x7D\x7Crichfind\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "cyber@yahoo.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:}|richfind.com\u{0a}")))))
; ^[0-9]{6}$
(assert (not (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
