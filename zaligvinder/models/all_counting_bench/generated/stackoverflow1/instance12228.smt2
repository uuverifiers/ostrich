;test regex $str = "{0}.*{1}" -f $ArrayA[j],$ArrayB[j]
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ ((_ re.loop 0 0) (str.to_re "\u{22}")) (re.++ ((_ re.loop 1 1) (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "f") (str.to_re " ")))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "r") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "y") (re.++ (str.to_re "A") (str.to_re "j"))))))))) (str.to_re ",")) (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "r") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "y") (re.++ (str.to_re "B") (str.to_re "j")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)