;test regex \^CV_((\w+)-){1,2}Base
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "^") (re.++ (str.to_re "C") (re.++ (str.to_re "V") (re.++ (str.to_re "_") (re.++ ((_ re.loop 1 2) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (str.to_re "-"))) (re.++ (str.to_re "B") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (str.to_re "e")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)