;test regex ^7.{3}[MY].{4}[MW]A
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "7") (re.++ ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re "M") (str.to_re "Y")) (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re "M") (str.to_re "W")) (str.to_re "A")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)