;test regex Eg: [A-Z1-9]{1,30}?[A-Z]{0,1}$[1-9]{0,1}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "E") (re.++ (str.to_re "g") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 30) (re.union (re.range "A" "Z") (re.range "1" "9"))) ((_ re.loop 0 1) (re.range "A" "Z"))))))) (re.++ (str.to_re "") ((_ re.loop 0 1) (re.range "1" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)