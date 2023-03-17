;test regex ^(?:11|22|33)[0-9]{8} TQ [0-9]{4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (str.to_re "11") (str.to_re "22")) (str.to_re "33")) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "T") (re.++ (str.to_re "Q") (re.++ (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)