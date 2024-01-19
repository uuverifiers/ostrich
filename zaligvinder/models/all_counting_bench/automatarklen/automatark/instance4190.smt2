(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 62[0-9]{14,17}
(assert (not (str.in_re X (re.++ (str.to_re "62") ((_ re.loop 14 17) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
