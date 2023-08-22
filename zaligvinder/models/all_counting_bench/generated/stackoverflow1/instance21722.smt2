;test regex ([A-Z0-9]{6})(?:.|\n)*(?:\s*finalText)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (re.* (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{0a}"))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "T") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (str.to_re "t"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)