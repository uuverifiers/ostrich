(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; for mobile:^[0][1-9]{1}[0-9]{9}$
(assert (str.in_re X (re.++ (str.to_re "for mobile:0") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(19|20)\d\d[-/.]([1-9]|0[1-9]|1[012])[- /.]([1-9]|0[1-9]|[12][0-9]|3[01])$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "19") (str.to_re "20")) (re.range "0" "9") (re.range "0" "9") (re.union (str.to_re "-") (str.to_re "/") (str.to_re ".")) (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "/") (str.to_re ".")) (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "\u{0a}")))))
; Subject\x3A\.bmpfromemail=couponbar\.coupons\.comToolbarxml\.alexa\.com
(assert (not (str.in_re X (str.to_re "Subject:.bmpfromemail=couponbar.coupons.comToolbarxml.alexa.com\u{0a}"))))
; passcorrect\x3B\d+AcmeSubject\x3Aready\.\r\nby\x2Fcbn\x2Fnode=
(assert (not (str.in_re X (re.++ (str.to_re "passcorrect;") (re.+ (re.range "0" "9")) (str.to_re "AcmeSubject:ready.\u{0d}\u{0a}by/cbn/node=\u{0a}")))))
(check-sat)
