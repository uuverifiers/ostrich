(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?(\d?\d?\d?,?)?(\d{3}\,?)*(\.?\d+)$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.++ (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (str.to_re "\u{0a}") (re.opt (str.to_re ".")) (re.+ (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
