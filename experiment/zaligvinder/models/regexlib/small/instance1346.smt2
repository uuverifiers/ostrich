;test regex megaupload\.com.*(?:\?|&)(?:(?:folderi)?d|f)=([A-Z-a-z0-9]{8})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "a") (re.++ (str.to_re "u") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re "?") (str.to_re "&")) (re.++ (re.union (re.++ (re.opt (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (str.to_re "i")))))))) (str.to_re "d")) (str.to_re "f")) (re.++ (str.to_re "=") ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.union (str.to_re "-") (re.union (re.range "a" "z") (re.range "0" "9")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)