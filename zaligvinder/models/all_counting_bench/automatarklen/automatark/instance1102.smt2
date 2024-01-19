(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z]{2}\/testcon.php$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "/testcon") re.allchar (str.to_re "php/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
