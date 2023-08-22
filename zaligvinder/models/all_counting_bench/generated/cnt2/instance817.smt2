;test regex ^(?:[a-z0-9A-Z]{32}|[-a-z0-9]{2,28}|\$[A-Z][A-Z0-9_]*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.range "A" "Z")))) ((_ re.loop 2 28) (re.union (str.to_re "-") (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.++ (str.to_re "$") (re.++ (re.range "A" "Z") (re.* (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)