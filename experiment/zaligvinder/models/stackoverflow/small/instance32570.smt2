;test regex (.*@.*com)(([^\";\n]*|\"[^\"\n]*\");){8}(([^\";\n]*|\"[^\"\n]*\"))
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "@") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m")))))) (re.++ ((_ re.loop 8 8) (re.++ (re.union (re.* (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.inter (re.diff re.allchar (str.to_re ";")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.diff re.allchar (str.to_re "\u{0a}")))) (str.to_re "\u{22}")))) (str.to_re ";"))) (re.union (re.* (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.inter (re.diff re.allchar (str.to_re ";")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.diff re.allchar (str.to_re "\u{0a}")))) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)