(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x5D\u{25}20\x5BPort_X-Mailer\x3AX-Mailer\u{3a}www\.actualnames\.comwebsearch\.getmirar\.com
(assert (str.in_re X (str.to_re "]%20[Port_X-Mailer:\u{13}X-Mailer:\u{13}www.actualnames.comwebsearch.getmirar.com\u{0a}")))
; ^1?[1-2]$|^[1-9]$|^[1]0$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "1")) (re.range "1" "2")) (re.range "1" "9") (str.to_re "10\u{0a}")))))
; ((\d{4})|(\d{2}))|(0?[2469]|11)(-|\/)((0[0-9])|([12])([0-9]?)|(3[0]?))(-|\/)((0?[13578]|10|12)(-|\/)((0[0-9])|([12])([0-9]?)|(3[01]?))(-|\/)((\d{4}|\d{2})))
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.opt (re.range "0" "9"))) (re.++ (str.to_re "3") (re.opt (str.to_re "0")))) (re.union (str.to_re "-") (str.to_re "/")) (str.to_re "\u{0a}") (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (str.to_re "10") (str.to_re "12")) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.opt (re.range "0" "9"))) (re.++ (str.to_re "3") (re.opt (re.union (str.to_re "0") (str.to_re "1"))))) (re.union (str.to_re "-") (str.to_re "/")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))))))
; ^([L|U]{1})([0-9]{5})([A-Za-z]{2})([0-9]{4})([A-Za-z]{3})([0-9]{6})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "L") (str.to_re "|") (str.to_re "U"))) ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
