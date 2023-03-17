;test regex ls | grep -E '^([^a-z]*[a-z][^a-z]*){5}$'
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "l") (re.++ (str.to_re "s") (str.to_re " "))) (re.++ (re.++ (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))) (re.++ (str.to_re "") ((_ re.loop 5 5) (re.++ (re.* (re.diff re.allchar (re.range "a" "z"))) (re.++ (re.range "a" "z") (re.* (re.diff re.allchar (re.range "a" "z")))))))) (re.++ (str.to_re "") (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)