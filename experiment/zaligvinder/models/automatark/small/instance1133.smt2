(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((\+351|00351|351)?)(2\d{1}|(9(3|6|2|1)))\d{7}
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+351") (str.to_re "00351") (str.to_re "351"))) (re.union (re.++ (str.to_re "2") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "9") (re.union (str.to_re "3") (str.to_re "6") (str.to_re "2") (str.to_re "1")))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
