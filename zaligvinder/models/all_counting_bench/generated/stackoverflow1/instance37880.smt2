;test regex \d{2}Some\{33\}\w{5}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "S") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "{") (re.++ (str.to_re "33") (re.++ (str.to_re "}") ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)