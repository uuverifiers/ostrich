(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^1000([.][0]{1,3})?$|^\d{1,3}$|^\d{1,3}([.]\d{1,3})$|^([.]\d{1,3})$
(assert (str.in_re X (re.union (re.++ (str.to_re "1000") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (str.to_re "0"))))) ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}.") ((_ re.loop 1 3) (re.range "0" "9"))))))
; 3A\s+URLBlazeHost\x3Atrackhjhgquqssq\u{2f}pjm
(assert (str.in_re X (re.++ (str.to_re "3A") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlazeHost:trackhjhgquqssq/pjm\u{0a}"))))
; e2give\.com.*Redirector\u{22}.*Host\x3A
(assert (str.in_re X (re.++ (str.to_re "e2give.com") (re.* re.allchar) (str.to_re "Redirector\u{22}") (re.* re.allchar) (str.to_re "Host:\u{0a}"))))
(check-sat)
