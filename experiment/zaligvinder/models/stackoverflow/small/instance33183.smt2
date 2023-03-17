;test regex where colA rlike '^P[0-9]{4}$';
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "w") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "A") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "P") ((_ re.loop 4 4) (re.range "0" "9"))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{27}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)