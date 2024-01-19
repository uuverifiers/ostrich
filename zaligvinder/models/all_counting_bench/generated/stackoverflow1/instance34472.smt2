;test regex perl -pe 's|.*?((\d{1,3}\.){3})xxx.*|${1}0|'
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (str.to_re "s"))))))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "."))) (re.++ (str.to_re "x") (re.++ (str.to_re "x") (re.++ (str.to_re "x") (re.* (re.diff re.allchar (str.to_re "\n"))))))))) (re.++ ((_ re.loop 1 1) (str.to_re "")) (str.to_re "0"))) (str.to_re "\u{27}"))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)