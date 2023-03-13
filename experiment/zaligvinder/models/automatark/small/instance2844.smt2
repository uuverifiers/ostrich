(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]{12},)+[0-9]{12}$|^([0-9]{12})$
(assert (str.in_re X (re.union (re.++ (re.+ (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; .*[Vv][Ii1]agr.*
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "V") (str.to_re "v")) (re.union (str.to_re "I") (str.to_re "i") (str.to_re "1")) (str.to_re "agr") (re.* re.allchar) (str.to_re "\u{0a}")))))
(check-sat)
