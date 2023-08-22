(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d?)*(\.\d{1}|\.\d{2})?$
(assert (not (str.in_re X (re.++ (re.* (re.opt (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") (re.union ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
