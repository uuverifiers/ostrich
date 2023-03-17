;test regex ^(AAAAA.{5}).{4}(.*)$       $17777$2
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "A") (re.++ (str.to_re "A") (re.++ (str.to_re "A") (re.++ (str.to_re "A") (re.++ (str.to_re "A") ((_ re.loop 5 5) (re.diff re.allchar (str.to_re "\n")))))))) (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.* (re.diff re.allchar (str.to_re "\n")))))) (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (str.to_re " "))))))))) (re.++ (str.to_re "") (str.to_re "17777"))) (re.++ (str.to_re "") (str.to_re "2")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)