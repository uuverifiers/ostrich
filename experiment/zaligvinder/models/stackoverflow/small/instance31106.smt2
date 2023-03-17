;test regex \sscore="(5\.[1-9]|[6-9]\.[0-9]|[1-9]{1}[0-9]{1,2}\.[0-9])"\s
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (str.to_re "s") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.union (re.++ (str.to_re "5") (re.++ (str.to_re ".") (re.range "1" "9"))) (re.++ (re.range "6" "9") (re.++ (str.to_re ".") (re.range "0" "9")))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ".") (re.range "0" "9"))))) (re.++ (str.to_re "\u{22}") (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)