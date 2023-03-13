(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+-]?\d+(\,\d{2})? *?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (str.to_re "\u{0a}")))))
(check-sat)
