(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[A-Z\d]{83}\u{3d}[A-Z\d]{10}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 83 83) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 10 10) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
