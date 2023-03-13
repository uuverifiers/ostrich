(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^1000([.][0]{1,3})?$|^\d{1,3}$|^\d{1,3}([.]\d{1,3})$|^([.]\d{1,3})$
(assert (str.in_re X (re.union (re.++ (str.to_re "1000") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (str.to_re "0"))))) ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}.") ((_ re.loop 1 3) (re.range "0" "9"))))))
(check-sat)
