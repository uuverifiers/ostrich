(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d(\.\d{1,2})?$
(assert (str.in_re X (re.++ (re.range "0" "9") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^[-+]?(\d?\d?\d?,?)?(\d{3}\,?)*$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.++ (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (str.to_re "\u{0a}"))))
; securityon\x3AHost\x3ARedirector\u{22}ServerHost\x3A
(assert (str.in_re X (str.to_re "securityon:Host:Redirector\u{22}ServerHost:\u{0a}")))
(check-sat)
