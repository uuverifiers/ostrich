;test regex [c-ik-lo-za]{5}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 5 5) (re.union (re.range "c" "i") (re.union (re.range "k" "l") (re.union (re.range "o" "z") (str.to_re "a")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)