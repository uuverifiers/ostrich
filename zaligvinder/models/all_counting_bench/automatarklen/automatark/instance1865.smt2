(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; CUSTOM\swww\x2Elocators\x2Ecom\d+Seconds\-
(assert (not (str.in_re X (re.++ (str.to_re "CUSTOM") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.locators.com") (re.+ (re.range "0" "9")) (str.to_re "Seconds-\u{0a}")))))
; [0-9][.][0-9]{3}$
(assert (not (str.in_re X (re.++ (re.range "0" "9") (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\x2Fmrow\x5Fpin\x2F\x3Fid\d+[a-z]{5,}\d{5}\u{26}rnd\x3D\d+/smi
(assert (not (str.in_re X (re.++ (str.to_re "//mrow_pin/?id") (re.+ (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "&rnd=") (re.+ (re.range "0" "9")) (str.to_re "/smi\u{0a}") ((_ re.loop 5 5) (re.range "a" "z")) (re.* (re.range "a" "z"))))))
(assert (> (str.len X) 10))
(check-sat)
