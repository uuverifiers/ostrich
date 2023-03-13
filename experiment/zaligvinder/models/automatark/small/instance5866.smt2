(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\+){1}91){1}[1-9]{1}[0-9]{9}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (str.to_re "+")) (str.to_re "91"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
