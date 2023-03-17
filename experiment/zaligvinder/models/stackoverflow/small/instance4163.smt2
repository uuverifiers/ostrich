;test regex [HEADER].{3}$[.FOOTER]
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (str.to_re "H") (re.union (str.to_re "E") (re.union (str.to_re "A") (re.union (str.to_re "D") (re.union (str.to_re "E") (str.to_re "R")))))) ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "") (re.union (str.to_re ".") (re.union (str.to_re "F") (re.union (str.to_re "O") (re.union (str.to_re "O") (re.union (str.to_re "T") (re.union (str.to_re "E") (str.to_re "R")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)