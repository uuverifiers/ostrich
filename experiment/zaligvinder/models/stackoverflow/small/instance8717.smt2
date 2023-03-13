;test regex ^([wgabc][pmx][0-9a-f]{3}-[0-9a-f]{3})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "w") (re.union (str.to_re "g") (re.union (str.to_re "a") (re.union (str.to_re "b") (str.to_re "c"))))) (re.++ (re.union (str.to_re "p") (re.union (str.to_re "m") (str.to_re "x"))) (re.++ ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "a" "f")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)