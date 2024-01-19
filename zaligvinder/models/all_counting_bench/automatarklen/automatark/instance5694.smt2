(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\?q=[^&]*##1$/U
(assert (str.in_re X (re.++ (str.to_re "//?q=") (re.* (re.comp (str.to_re "&"))) (str.to_re "##1/U\u{0a}"))))
; /\u{2f}n\.php\?h=[a-zA-Z0-9]*?\&s=[a-zA-Z0-9]{1,5}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//n.php?h=") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "&s=") ((_ re.loop 1 5) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
; thesearchresltLoggerHost\x3ABetaHWAEHost\x3Ais
(assert (not (str.in_re X (str.to_re "thesearchresltLoggerHost:BetaHWAEHost:is\u{0a}"))))
; passcorrect\x3B\d+AcmeSubject\x3Aready\.\r\nby\x2Fcbn\x2Fnode=
(assert (str.in_re X (re.++ (str.to_re "passcorrect;") (re.+ (re.range "0" "9")) (str.to_re "AcmeSubject:ready.\u{0d}\u{0a}by/cbn/node=\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
