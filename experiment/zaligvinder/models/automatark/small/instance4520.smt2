(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (not (str.in_re X (str.to_re "http://tv.seekmo.com/showme.aspx?keyword=\u{0a}"))))
; /\x2Fmrow\x5Fpin\x2F\x3Fid\d+[a-z]{5,}\d{5}\u{26}rnd\x3D\d+/smi
(assert (str.in_re X (re.++ (str.to_re "//mrow_pin/?id") (re.+ (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "&rnd=") (re.+ (re.range "0" "9")) (str.to_re "/smi\u{0a}") ((_ re.loop 5 5) (re.range "a" "z")) (re.* (re.range "a" "z")))))
; \d+,?\d+\$?
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ",")) (re.+ (re.range "0" "9")) (re.opt (str.to_re "$")) (str.to_re "\u{0a}"))))
(check-sat)
