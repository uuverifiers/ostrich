;test regex ^(.*) at (\d{1,2}[a|p]m.*) for (.*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.union (str.to_re "a") (re.union (str.to_re "|") (str.to_re "p"))) (re.++ (str.to_re "m") (re.* (re.diff re.allchar (str.to_re "\n")))))) (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)