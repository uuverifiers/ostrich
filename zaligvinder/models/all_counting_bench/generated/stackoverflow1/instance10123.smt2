;test regex $number_exp = "<^([^0][1-9]+)?([0]{1})?[.|,]?[0-9]{0,4}$>";
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "_") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (str.to_re "<")))))))))))))))) (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.diff re.allchar (str.to_re "0")) (re.+ (re.range "1" "9")))) (re.++ (re.opt ((_ re.loop 1 1) (str.to_re "0"))) (re.++ (re.opt (re.union (str.to_re ".") (re.union (str.to_re "|") (str.to_re ",")))) ((_ re.loop 0 4) (re.range "0" "9"))))))) (re.++ (str.to_re "") (re.++ (str.to_re ">") (re.++ (str.to_re "\u{22}") (str.to_re ";")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)