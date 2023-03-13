(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\+65)?\d{8}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+65")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
