;test regex FVAL\("?\w+"?(?:,"?\w+"?){0,2}\)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "F") (re.++ (str.to_re "V") (re.++ (str.to_re "A") (re.++ (str.to_re "L") (re.++ (str.to_re "(") (re.++ (re.opt (str.to_re "\u{22}")) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.opt (str.to_re "\u{22}")) (re.++ ((_ re.loop 0 2) (re.++ (str.to_re ",") (re.++ (re.opt (str.to_re "\u{22}")) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.opt (str.to_re "\u{22}")))))) (str.to_re ")"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)