;test regex [a-z_]+\.[a-z]{2,4}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (str.to_re "_"))) (re.++ (str.to_re ".") ((_ re.loop 2 4) (re.range "a" "z"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)