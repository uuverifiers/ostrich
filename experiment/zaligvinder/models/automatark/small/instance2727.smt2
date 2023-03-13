(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; iz=Referer\x3Aoffers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "iz=Referer:offers.bullseye-network.com\u{0a}"))))
; (^\d*\.\d{2}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))
; is\x7D\x7BPort\x3A\x7D\x7BUser\x3A
(assert (str.in_re X (str.to_re "is}{Port:}{User:\u{0a}")))
; e(vi?)?
(assert (not (str.in_re X (re.++ (str.to_re "e") (re.opt (re.++ (str.to_re "v") (re.opt (str.to_re "i")))) (str.to_re "\u{0a}")))))
(check-sat)
