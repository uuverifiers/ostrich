(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[0-9A-F]{24}/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/Ui\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
