(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; securityon\x3AHost\x3ARedirector\u{22}ServerHost\x3A
(assert (str.in_re X (str.to_re "securityon:Host:Redirector\u{22}ServerHost:\u{0a}")))
; /^\/[a-f0-9]{32}\/\d{10}\/[a-f0-9]{32}\.jar$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".jar/Ui\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
