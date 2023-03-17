;test regex z1 <- grep("\\d{2}!!\\d{2}!!\\d{2}", z, value=TRUE)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "z") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "<") (re.++ (str.to_re "-") (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (str.to_re "d")) (re.++ (str.to_re "!") (re.++ (str.to_re "!") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (str.to_re "d")) (re.++ (str.to_re "!") (re.++ (str.to_re "!") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{22}")))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "z")))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re "U") (str.to_re "E")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)