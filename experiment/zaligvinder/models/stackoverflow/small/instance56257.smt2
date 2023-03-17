;test regex Cell1{1,2} = -(f32.*x1.*x6)./v1
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "C") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ ((_ re.loop 1 2) (str.to_re "1")) (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (re.++ (str.to_re "f") (re.++ (str.to_re "32") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "x") (re.++ (str.to_re "1") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "x") (str.to_re "6")))))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "/") (re.++ (str.to_re "v") (str.to_re "1"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)