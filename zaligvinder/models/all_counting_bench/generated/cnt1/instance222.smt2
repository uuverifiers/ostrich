;test regex ^([A-Z0-9]{8,12}|[b-zB-Z0-9]{15}|NOQUEUE): (.+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union ((_ re.loop 8 12) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 15 15) (re.union (re.range "b" "z") (re.union (re.range "B" "Z") (re.range "0" "9"))))) (re.++ (str.to_re "N") (re.++ (str.to_re "O") (re.++ (str.to_re "Q") (re.++ (str.to_re "U") (re.++ (str.to_re "E") (re.++ (str.to_re "U") (str.to_re "E")))))))) (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.+ (re.diff re.allchar (str.to_re "\n"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)