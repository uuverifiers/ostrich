(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /setup=[a-z]\&s=\d\&r=\d{5}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/setup=") (re.range "a" "z") (str.to_re "&s=") (re.range "0" "9") (str.to_re "&r=") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
