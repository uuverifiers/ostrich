(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[A-Za-z0-9]{33}\?s=\d\&m=\d$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 33 33) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "?s=") (re.range "0" "9") (str.to_re "&m=") (re.range "0" "9") (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
