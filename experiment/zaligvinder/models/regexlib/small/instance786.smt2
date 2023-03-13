;test regex [\w\-_\+\(\)]{0,}[\.png|\.PNG]{4}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.union (str.to_re "-") (re.union (str.to_re "_") (re.union (str.to_re "+") (re.union (str.to_re "(") (str.to_re ")"))))))) ((_ re.loop 0 0) (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.union (str.to_re "-") (re.union (str.to_re "_") (re.union (str.to_re "+") (re.union (str.to_re "(") (str.to_re ")")))))))) ((_ re.loop 4 4) (re.union (str.to_re ".") (re.union (str.to_re "p") (re.union (str.to_re "n") (re.union (str.to_re "g") (re.union (str.to_re "|") (re.union (str.to_re ".") (re.union (str.to_re "P") (re.union (str.to_re "N") (str.to_re "G")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)