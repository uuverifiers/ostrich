;test regex ^[aA-zZ\u00C0-\u017F- \']{2,}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.union (str.to_re "a") (re.union (re.range "A" "z") (re.union (str.to_re "Z") (re.union (re.range "\u{00c0}" "\u{017f}") (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re "\u{27}")))))))) ((_ re.loop 2 2) (re.union (str.to_re "a") (re.union (re.range "A" "z") (re.union (str.to_re "Z") (re.union (re.range "\u{00c0}" "\u{017f}") (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re "\u{27}")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)