(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/14\d{8}(.jar)?$/U
(assert (not (str.in_re X (re.++ (str.to_re "//14") ((_ re.loop 8 8) (re.range "0" "9")) (re.opt (re.++ re.allchar (str.to_re "jar"))) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
