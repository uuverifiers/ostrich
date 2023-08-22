;test regex ([0-9]{2}80|[0-9]80[0-9]|80[0-9]{2}|0515)$|_0043722_
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.union (re.union (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "80")) (re.++ (re.range "0" "9") (re.++ (str.to_re "80") (re.range "0" "9")))) (re.++ (str.to_re "80") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "0515")) (str.to_re "")) (re.++ (str.to_re "_") (re.++ (str.to_re "0043722") (str.to_re "_"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)