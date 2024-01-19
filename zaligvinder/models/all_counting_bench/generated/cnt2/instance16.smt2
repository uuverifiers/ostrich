;test regex ^ETRN [^\x0A]{500}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "E") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re "N") (re.++ (str.to_re " ") ((_ re.loop 500 500) (re.diff re.allchar (str.to_re "\u{0a}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)