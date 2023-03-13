(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-]?\d{1,10}\.?([0-9][0-9])?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 10) (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.++ (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
