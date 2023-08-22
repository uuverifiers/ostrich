(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{3}[.-]?\d{3}[.-]?\d{4}
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[+-]?([0-9]*\.?[0-9]+|[0-9]+\.?[0-9]*)([eE][+-]?[0-9]+)?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9"))) (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")))) (re.opt (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^[\w\.=-]+@[\w\.-]+\.[\w]{2,3}$
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re ".") (str.to_re "=") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
