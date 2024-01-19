(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/count\d{2}\.php$/U
(assert (str.in_re X (re.++ (str.to_re "//count") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".php/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
