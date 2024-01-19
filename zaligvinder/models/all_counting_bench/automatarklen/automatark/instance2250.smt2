(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\+\-]?\d+(,\d+)?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; \d{5,12}|\d{1,10}\.\d{1,10}\.\d{1,10}|\d{1,10}\.\d{1,10}
(assert (not (str.in_re X (re.union ((_ re.loop 5 12) (re.range "0" "9")) (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9"))) (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
