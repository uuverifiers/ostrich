(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([L|U]{1})([0-9]{5})([A-Za-z]{2})([0-9]{4})([A-Za-z]{3})([0-9]{6})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "L") (str.to_re "|") (str.to_re "U"))) ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /[A-F0-9]{8}(-[A-F0-9]{4}){3}-[A-F0-9]{12}.wipe$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "A" "F") (re.range "0" "9"))) ((_ re.loop 3 3) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "0" "9"))))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "F") (re.range "0" "9"))) re.allchar (str.to_re "wipe/Ui\u{0a}")))))
; ((8|\+7)-?)?\(?\d{3,5}\)?-?\d{1}-?\d{1}-?\d{1}-?\d{1}-?\d{1}((-?\d{1})?-?\d{1})?
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "8") (str.to_re "+7")) (re.opt (str.to_re "-")))) (re.opt (str.to_re "(")) ((_ re.loop 3 5) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)
