(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2EZSearchResults\x2Ecom\dBar.*sponsor2\.ucmore\.com
(assert (str.in_re X (re.++ (str.to_re "www.ZSearchResults.com\u{13}") (re.range "0" "9") (str.to_re "Bar") (re.* re.allchar) (str.to_re "sponsor2.ucmore.com\u{0a}"))))
; ^\(0[1-9]{1}\)[0-9]{8}$
(assert (str.in_re X (re.++ (str.to_re "(0") ((_ re.loop 1 1) (re.range "1" "9")) (str.to_re ")") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^\d+\*\d+\*\d+$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "*") (re.+ (re.range "0" "9")) (str.to_re "*") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
