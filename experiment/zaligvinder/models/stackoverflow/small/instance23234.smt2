;test regex ".*(([Rock]{4})|([Rock]{0})).*"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union ((_ re.loop 4 4) (re.union (str.to_re "R") (re.union (str.to_re "o") (re.union (str.to_re "c") (str.to_re "k"))))) ((_ re.loop 0 0) (re.union (str.to_re "R") (re.union (str.to_re "o") (re.union (str.to_re "c") (str.to_re "k")))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)