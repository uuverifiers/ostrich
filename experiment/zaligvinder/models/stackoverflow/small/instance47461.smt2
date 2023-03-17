;test regex [0,1,2,3]\d[0,1]\d{4}50[0,5]\d{3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "0") (re.union (str.to_re ",") (re.union (str.to_re "1") (re.union (str.to_re ",") (re.union (str.to_re "2") (re.union (str.to_re ",") (str.to_re "3"))))))) (re.++ (re.range "0" "9") (re.++ (re.union (str.to_re "0") (re.union (str.to_re ",") (str.to_re "1"))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "50") (re.++ (re.union (str.to_re "0") (re.union (str.to_re ",") (str.to_re "5"))) ((_ re.loop 3 3) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)