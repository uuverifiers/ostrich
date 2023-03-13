(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (a|A)
(assert (str.in_re X (re.++ (re.union (str.to_re "a") (str.to_re "A")) (str.to_re "\u{0a}"))))
; ^(([0-9]|1[0-9]|2[0-4])(\.[0-9][0-9]?)?)$|([2][5](\.[0][0]?)?)$
(assert (not (str.in_re X (re.union (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4"))) (re.opt (re.++ (str.to_re ".") (re.range "0" "9") (re.opt (re.range "0" "9"))))) (re.++ (str.to_re "\u{0a}25") (re.opt (re.++ (str.to_re ".0") (re.opt (str.to_re "0")))))))))
; /\u{2f}blackmuscats?\u{3f}\d/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//blackmuscat") (re.opt (str.to_re "s")) (str.to_re "?") (re.range "0" "9") (str.to_re "/Ui\u{0a}")))))
; ^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "1" "9")) (re.++ (re.range "0" "9") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
