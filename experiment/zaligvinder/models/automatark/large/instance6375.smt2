(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^GET \x2F3010[0-9A-F]{166}00000001/
(assert (str.in_re X (re.++ (str.to_re "/GET /3010") ((_ re.loop 166 166) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "00000001/\u{0a}"))))
; ^([1-9]{1}[0-9]{3}[,]?)*([1-9]{1}[0-9]{3})$
(assert (not (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9"))))))
(check-sat)
