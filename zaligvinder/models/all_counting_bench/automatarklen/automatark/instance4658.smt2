(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(1?)(-| ?)(\()?([0-9]{3})(\)|-| |\)-|\) )?([0-9]{3})(-| )?([0-9]{4}|[0-9]{4})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "1")) (re.union (str.to_re "-") (re.opt (str.to_re " "))) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ")") (str.to_re "-") (str.to_re " ") (str.to_re ")-") (str.to_re ") "))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; securityon\x3AHost\x3ARedirector\u{22}ServerHost\x3A
(assert (not (str.in_re X (str.to_re "securityon:Host:Redirector\u{22}ServerHost:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)