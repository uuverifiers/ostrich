;test regex ^.*?(((1[03])*[ ]*(: ){0,1})*(([0-9Xx][- ]*){13}|([0-9Xx][- ]*){10})).*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.* (re.++ (re.* (re.++ (str.to_re "1") (str.to_re "03"))) (re.++ (re.* (str.to_re " ")) ((_ re.loop 0 1) (re.++ (str.to_re ":") (str.to_re " ")))))) (re.union ((_ re.loop 13 13) (re.++ (re.union (re.range "0" "9") (re.union (str.to_re "X") (str.to_re "x"))) (re.* (re.union (str.to_re "-") (str.to_re " "))))) ((_ re.loop 10 10) (re.++ (re.union (re.range "0" "9") (re.union (str.to_re "X") (str.to_re "x"))) (re.* (re.union (str.to_re "-") (str.to_re " "))))))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)