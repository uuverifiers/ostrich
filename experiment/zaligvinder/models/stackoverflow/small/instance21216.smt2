;test regex ^([A-z0-9_.]{2,})([@]{1})([A-z]{1,})([.]{1})([A-z.]{1,})*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.union (re.range "A" "z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (str.to_re "."))))) ((_ re.loop 2 2) (re.union (re.range "A" "z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (str.to_re ".")))))) (re.++ ((_ re.loop 1 1) (str.to_re "@")) (re.++ (re.++ (re.* (re.range "A" "z")) ((_ re.loop 1 1) (re.range "A" "z"))) (re.++ ((_ re.loop 1 1) (str.to_re ".")) (re.* (re.++ (re.* (re.union (re.range "A" "z") (str.to_re "."))) ((_ re.loop 1 1) (re.union (re.range "A" "z") (str.to_re ".")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)