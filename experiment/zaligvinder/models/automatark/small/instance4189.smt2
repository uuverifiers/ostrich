(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(.){0,20}$
(assert (not (str.in_re X (re.++ ((_ re.loop 0 20) re.allchar) (str.to_re "\u{0a}")))))
(check-sat)
