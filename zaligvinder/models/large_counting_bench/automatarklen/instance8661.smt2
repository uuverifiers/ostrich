(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9]{1,20}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 20) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; (\\.|[^"])*
(assert (not (str.in_re X (re.++ (re.* (re.union (re.++ (str.to_re "\u{5c}") re.allchar) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{0a}")))))
; /[a-z\d\u{2f}\u{2b}\u{3d}]{100}/AGPi
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 100 100) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "/") (str.to_re "+") (str.to_re "="))) (str.to_re "/AGPi\u{0a}"))))
; (^(((\d)|(\d\d)|(\d\d\d))(\xA0|\u{20}))*((\d)|(\d\d)|(\d\d\d))([,.]\d*)?$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.++ (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (re.union (str.to_re "\u{a0}") (str.to_re " ")))) (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (re.opt (re.++ (re.union (str.to_re ",") (str.to_re ".")) (re.* (re.range "0" "9")))))))
(assert (< 200 (str.len X)))
(check-sat)
