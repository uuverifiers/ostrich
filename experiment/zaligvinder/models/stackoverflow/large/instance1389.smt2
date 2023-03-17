;test regex REF([123],[456]),REF([789],[456]),{111},REF([8069],[8098])
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "F") (re.++ (str.to_re "123") (re.++ (str.to_re ",") (str.to_re "456")))))) (re.++ (str.to_re ",") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "F") (re.++ (str.to_re "789") (re.++ (str.to_re ",") (str.to_re "456")))))))) ((_ re.loop 111 111) (str.to_re ","))) (re.++ (str.to_re ",") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "F") (re.++ (str.to_re "8069") (re.++ (str.to_re ",") (str.to_re "8098"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)