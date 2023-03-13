(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(0?\d|1[012])\/([012]?\d|3[01])\/(\d{2}|\d{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re "/") (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2"))) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "/") (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; A-311www3\.addfreestats\.comAttachedX-Mailer\x3A
(assert (str.in_re X (str.to_re "A-311www3.addfreestats.comAttachedX-Mailer:\u{13}\u{0a}")))
(check-sat)
