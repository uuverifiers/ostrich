;test regex NSString *regex = @"\\b-?1?[0-9]{2}(\\.[0-9]{1,2})?\\b";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "N") (re.++ (str.to_re "S") (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "@") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (re.opt (str.to_re "-")) (re.++ (re.opt (str.to_re "1")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (str.to_re "\u{22}") (str.to_re ";")))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)