;test regex [A-Z][ ]*(?:\d(?:[ ]*[A-Z]){2}|[A-Z][ ]*\d[ ]*[A-Z]|(?:[A-Z][ ]*){2,}\d?)[A-Z ]*[A-Z]
(declare-const X String)
(assert (str.in_re X (re.++ (re.range "A" "Z") (re.++ (re.* (str.to_re " ")) (re.++ (re.union (re.union (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.++ (re.* (str.to_re " ")) (re.range "A" "Z")))) (re.++ (re.range "A" "Z") (re.++ (re.* (str.to_re " ")) (re.++ (re.range "0" "9") (re.++ (re.* (str.to_re " ")) (re.range "A" "Z")))))) (re.++ (re.++ (re.* (re.++ (re.range "A" "Z") (re.* (str.to_re " ")))) ((_ re.loop 2 2) (re.++ (re.range "A" "Z") (re.* (str.to_re " "))))) (re.opt (re.range "0" "9")))) (re.++ (re.* (re.union (re.range "A" "Z") (str.to_re " "))) (re.range "A" "Z")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)