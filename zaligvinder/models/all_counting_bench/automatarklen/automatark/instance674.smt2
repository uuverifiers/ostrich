(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ProAgent\d+X-Mailer\x3Abacktrust\x2EcomReferer\u{3a}Supreme
(assert (not (str.in_re X (re.++ (str.to_re "ProAgent") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer:\u{13}backtrust.comReferer:Supreme\u{0a}")))))
; ^([^\s]){5,12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
