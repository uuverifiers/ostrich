;test regex ^(.*-bucket-logs)(-[a-z]{2}-[a-z]{4,}-\d)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "-") (re.++ (str.to_re "b") (re.++ (str.to_re "u") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "-") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "g") (str.to_re "s"))))))))))))) (re.opt (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "-") (re.++ (re.++ (re.* (re.range "a" "z")) ((_ re.loop 4 4) (re.range "a" "z"))) (re.++ (str.to_re "-") (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)