;test regex ^[C,E,F][O,C,X,R][0-9]{4}(/{1})[0-9]{1,8}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (str.to_re "C") (re.union (str.to_re ",") (re.union (str.to_re "E") (re.union (str.to_re ",") (str.to_re "F"))))) (re.++ (re.union (str.to_re "O") (re.union (str.to_re ",") (re.union (str.to_re "C") (re.union (str.to_re ",") (re.union (str.to_re "X") (re.union (str.to_re ",") (str.to_re "R"))))))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re "/")) ((_ re.loop 1 8) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)