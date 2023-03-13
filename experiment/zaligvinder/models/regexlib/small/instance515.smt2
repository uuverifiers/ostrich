;test regex [NS] \d{1,}(\:[0-5]\d){2}.{0,1}\d{0,},[EW] \d{1,}(\:[0-5]\d){2}.{0,1}\d{0,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (str.to_re "N") (str.to_re "S")) (re.++ (str.to_re " ") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.range "0" "9")))) (re.++ ((_ re.loop 0 1) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 0 0) (re.range "0" "9")))))))) (re.++ (str.to_re ",") (re.++ (re.union (str.to_re "E") (str.to_re "W")) (re.++ (str.to_re " ") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.range "0" "9")))) (re.++ ((_ re.loop 0 1) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 0 0) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)