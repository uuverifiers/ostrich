(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; EIcdpnode=reportUID\x2FServertoX-Mailer\u{3a}
(assert (not (str.in_re X (str.to_re "EIcdpnode=reportUID/ServertoX-Mailer:\u{13}\u{0a}"))))
; (^\d{1,9})+(,\d{1,9})*$
(assert (not (str.in_re X (re.++ (re.+ ((_ re.loop 1 9) (re.range "0" "9"))) (re.* (re.++ (str.to_re ",") ((_ re.loop 1 9) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
