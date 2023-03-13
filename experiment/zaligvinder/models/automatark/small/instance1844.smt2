(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Controlsource%3Dultrasearch136%26campaign%3Dsnap
(assert (str.in_re X (str.to_re "Controlsource%3Dultrasearch136%26campaign%3Dsnap\u{0a}")))
; ^[A-z]?\d{8}[A-z]$
(assert (str.in_re X (re.++ (re.opt (re.range "A" "z")) ((_ re.loop 8 8) (re.range "0" "9")) (re.range "A" "z") (str.to_re "\u{0a}"))))
(check-sat)
