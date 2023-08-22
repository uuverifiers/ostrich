(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}[A-F0-9]{158}/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 158 158) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; securityon\x3AHost\x3ARedirector\u{22}ServerHost\x3A
(assert (str.in_re X (str.to_re "securityon:Host:Redirector\u{22}ServerHost:\u{0a}")))
(assert (< 200 (str.len X)))
(check-sat)
