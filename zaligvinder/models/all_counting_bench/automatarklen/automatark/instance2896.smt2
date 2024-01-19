(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}fli/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fli/i\u{0a}"))))
; ovpl\s+\x7D\x7BPort\x3A.*SOAPAction\x3A.*adfsgecoiwnfHost\x3A\x3Fsearch\x3D
(assert (str.in_re X (re.++ (str.to_re "ovpl") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Port:") (re.* re.allchar) (str.to_re "SOAPAction:") (re.* re.allchar) (str.to_re "adfsgecoiwnf\u{1b}Host:?search=\u{0a}"))))
; /\x2Fmrow\x5Fpin\x2F\x3Fid\d+[a-z]{5,}\d{5}\u{26}rnd\x3D\d+/smi
(assert (str.in_re X (re.++ (str.to_re "//mrow_pin/?id") (re.+ (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "&rnd=") (re.+ (re.range "0" "9")) (str.to_re "/smi\u{0a}") ((_ re.loop 5 5) (re.range "a" "z")) (re.* (re.range "a" "z")))))
; /^\/cnt\.php\?id=\d+$/U
(assert (not (str.in_re X (re.++ (str.to_re "//cnt.php?id=") (re.+ (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
