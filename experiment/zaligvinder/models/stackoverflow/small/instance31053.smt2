;test regex ^(\$|)[A-Z0-9_\- ]*\t(?:[0-9\.\-]*\t){6}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "") (str.to_re "$")) (str.to_re "")) (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (re.union (str.to_re "-") (str.to_re " ")))))) (re.++ (str.to_re "\u{09}") ((_ re.loop 6 6) (re.++ (re.* (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "-")))) (str.to_re "\u{09}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)