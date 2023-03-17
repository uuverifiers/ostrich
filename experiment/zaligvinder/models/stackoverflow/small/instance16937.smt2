;test regex (^|(.*\D))2\D(.*[\D]){0,1}9($|\D.*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.diff re.allchar (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.diff re.allchar (re.range "0" "9")))) (re.++ (str.to_re "9") (re.union (str.to_re "") (re.++ (re.diff re.allchar (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)