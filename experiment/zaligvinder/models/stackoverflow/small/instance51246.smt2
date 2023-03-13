;test regex \.([pP][nN][gG]|[jJ][pP][eE]?[gG]|[gG][iI][fF]|[iI][cC][oO]|[tT][iI][fF]{1,2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re ".") (re.union (re.union (re.union (re.union (re.++ (re.union (str.to_re "p") (str.to_re "P")) (re.++ (re.union (str.to_re "n") (str.to_re "N")) (re.union (str.to_re "g") (str.to_re "G")))) (re.++ (re.union (str.to_re "j") (str.to_re "J")) (re.++ (re.union (str.to_re "p") (str.to_re "P")) (re.++ (re.opt (re.union (str.to_re "e") (str.to_re "E"))) (re.union (str.to_re "g") (str.to_re "G")))))) (re.++ (re.union (str.to_re "g") (str.to_re "G")) (re.++ (re.union (str.to_re "i") (str.to_re "I")) (re.union (str.to_re "f") (str.to_re "F"))))) (re.++ (re.union (str.to_re "i") (str.to_re "I")) (re.++ (re.union (str.to_re "c") (str.to_re "C")) (re.union (str.to_re "o") (str.to_re "O"))))) (re.++ (re.union (str.to_re "t") (str.to_re "T")) (re.++ (re.union (str.to_re "i") (str.to_re "I")) ((_ re.loop 1 2) (re.union (str.to_re "f") (str.to_re "F"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)