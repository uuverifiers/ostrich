;test regex '/^[a-z0-9#.,&;/ ]{2,255}$/i'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "\u{27}") (str.to_re "/")) (re.++ (str.to_re "") ((_ re.loop 2 255) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "#") (re.union (str.to_re ".") (re.union (str.to_re ",") (re.union (str.to_re "&") (re.union (str.to_re ";") (re.union (str.to_re "/") (str.to_re " ")))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (str.to_re "\u{27}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)