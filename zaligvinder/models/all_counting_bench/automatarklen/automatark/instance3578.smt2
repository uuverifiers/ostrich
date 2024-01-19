(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{6}$
(assert (not (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
