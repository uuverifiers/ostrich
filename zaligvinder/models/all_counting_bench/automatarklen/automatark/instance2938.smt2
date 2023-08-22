(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/blog\/images\/3521\.jpg\?v\d{2}=\d{2}\u{26}tq=/Ui
(assert (str.in_re X (re.++ (str.to_re "//blog/images/3521.jpg?v") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "=") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "&tq=/Ui\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
