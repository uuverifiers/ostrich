;test regex data= s.split("\\s*\\:\\s*|\\s{2,}");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "d") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (re.union (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (str.to_re "\\") (re.++ (str.to_re ":") (re.++ (str.to_re "\\") (re.* (str.to_re "s")))))))) (re.++ (str.to_re "\\") (re.++ (re.++ (re.* (str.to_re "s")) ((_ re.loop 2 2) (str.to_re "s"))) (str.to_re "\u{22}")))) (str.to_re ";")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)