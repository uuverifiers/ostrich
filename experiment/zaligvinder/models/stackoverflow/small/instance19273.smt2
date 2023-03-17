;test regex ^(?:[\u0590-\u05FF\uFB1D-\uFB40 ]{2,}|[\w ]{2,})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.* (re.union (re.range "\u{0590}" "\u{05ff}") (re.union (re.range "\u{fb1d}" "\u{fb40}") (str.to_re " ")))) ((_ re.loop 2 2) (re.union (re.range "\u{0590}" "\u{05ff}") (re.union (re.range "\u{fb1d}" "\u{fb40}") (str.to_re " "))))) (re.++ (re.* (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re " "))) ((_ re.loop 2 2) (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re " ")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)