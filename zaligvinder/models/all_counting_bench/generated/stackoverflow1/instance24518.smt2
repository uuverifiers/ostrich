;test regex ABC.*{15,50}DEF
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (str.to_re "C") (re.++ ((_ re.loop 15 50) (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "D") (re.++ (str.to_re "E") (str.to_re "F")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)