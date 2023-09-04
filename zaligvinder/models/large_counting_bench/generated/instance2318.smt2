;test regex [0-9A-Za-z-_.]{1,64}[\@][0-9a-zA-Z\-]{1,63}[\.][a-zA-Z\-]{2,24}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 64) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "-") (re.union (str.to_re "_") (str.to_re "."))))))) (re.++ (str.to_re "@") (re.++ ((_ re.loop 1 63) (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (str.to_re "-"))))) (re.++ (str.to_re ".") ((_ re.loop 2 24) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (str.to_re "-"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)