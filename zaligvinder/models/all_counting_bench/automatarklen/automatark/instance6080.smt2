(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z]{4}\.html\?h\=\d{6,7}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".html?h=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
