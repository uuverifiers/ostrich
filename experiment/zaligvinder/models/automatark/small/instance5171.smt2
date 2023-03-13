(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{1}\.){0,1}\d{1,3}\,\d{2}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
