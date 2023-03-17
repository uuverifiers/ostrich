;test regex ^(?:[2-9]{3}[a-z0-9]{7})$|^(?:[1-9]{4}[a-z0-9]{7})$|^(?:[0-9]{7}[a-z0-9]{5,})$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.range "2" "9")) ((_ re.loop 7 7) (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.range "1" "9")) ((_ re.loop 7 7) (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.range "0" "9")))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)