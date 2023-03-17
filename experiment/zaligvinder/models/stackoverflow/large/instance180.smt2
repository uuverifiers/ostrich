;test regex ^[ !',.0-9?A-Z]{1,4000}$/i
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 1 4000) (re.union (str.to_re " ") (re.union (str.to_re "!") (re.union (str.to_re "\u{27}") (re.union (str.to_re ",") (re.union (str.to_re ".") (re.union (re.range "0" "9") (re.union (str.to_re "?") (re.range "A" "Z")))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (str.to_re "i"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)