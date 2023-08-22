;test regex '#(.{10,75}' . $s . '.{10,75})#s'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "#") (re.++ (re.++ (re.++ ((_ re.loop 10 75) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re " "))))) (re.++ (str.to_re "") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") ((_ re.loop 10 75) (re.diff re.allchar (str.to_re "\n")))))))))) (re.++ (str.to_re "#") (re.++ (str.to_re "s") (str.to_re "\u{27}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)