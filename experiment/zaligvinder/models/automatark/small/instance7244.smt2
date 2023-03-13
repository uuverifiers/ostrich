(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Eweepee\x2Ecom\w+Owner\x3A\d+metaresults\.copernic\.com
(assert (not (str.in_re X (re.++ (str.to_re "www.weepee.com\u{1b}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:") (re.+ (re.range "0" "9")) (str.to_re "metaresults.copernic.com\u{0a}")))))
; ^([GB])*(([1-9]\d{8})|([1-9]\d{11}))$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "G") (str.to_re "B"))) (re.union (re.++ (re.range "1" "9") ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 11 11) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; $(\n|\r\n)
(assert (str.in_re X (re.++ (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}\u{0a}")) (str.to_re "\u{0a}"))))
(check-sat)
