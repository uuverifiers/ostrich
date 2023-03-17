;test regex ^([0-9])|([a-x]{300})|([x-z]{1,5})|([ab]{2,})$...
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "") (re.range "0" "9")) ((_ re.loop 300 300) (re.range "a" "x"))) ((_ re.loop 1 5) (re.range "x" "z"))) (re.++ (re.++ (re.* (re.union (str.to_re "a") (str.to_re "b"))) ((_ re.loop 2 2) (re.union (str.to_re "a") (str.to_re "b")))) (re.++ (str.to_re "") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)