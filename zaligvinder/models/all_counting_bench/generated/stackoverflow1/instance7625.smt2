;test regex grep -P '^--[a-fA-F0-9]{8}-[A-Z]--$'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "P") (re.++ (str.to_re " ") (str.to_re "\u{27}"))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "-") (re.++ (str.to_re "-") (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))) (re.++ (str.to_re "-") (re.++ (re.range "A" "Z") (re.++ (str.to_re "-") (str.to_re "-"))))))))) (re.++ (str.to_re "") (str.to_re "\u{27}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)