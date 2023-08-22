(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((2|8|9)\d{2})|((02|08|09)\d{2})|([1-9]\d{3}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "2") (str.to_re "8") (str.to_re "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "0") (re.union (str.to_re "2") (str.to_re "8") (str.to_re "9"))) (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(\+|-)?\d+$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; &#([0-9]{1,5}|x[0-9a-fA-F]{1,4});
(assert (str.in_re X (re.++ (str.to_re "&#") (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ (str.to_re "x") ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))) (str.to_re ";\u{0a}"))))
; ^(\d{5}((|-)-\d{4})?)|([A-Za-z]\d[A-Za-z][\s\.\-]?(|-)\d[A-Za-z]\d)|[A-Za-z]{1,2}\d{1,2}[A-Za-z]? \d[A-Za-z]{2}$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re "--") ((_ re.loop 4 4) (re.range "0" "9"))))) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-") (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9")) (re.++ ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re " ") (re.range "0" "9") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
