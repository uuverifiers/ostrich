;test regex jack.{0,100}john|john.{0,100}jack
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ ((_ re.loop 0 100) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "j") (re.++ (str.to_re "o") (re.++ (str.to_re "h") (str.to_re "n"))))))))) (re.++ (str.to_re "j") (re.++ (str.to_re "o") (re.++ (str.to_re "h") (re.++ (str.to_re "n") (re.++ ((_ re.loop 0 100) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "j") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (str.to_re "k"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)