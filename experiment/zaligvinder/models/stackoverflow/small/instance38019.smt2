;test regex ^[A-Z]*REF[A-Z]*([12]\d{3})(\d{6})(\d{2})$|^([12]\d{3})(\d{6})(\d{2})[A-Z]*REF[A-Z]*|^([12]\d{3})(\d{6})(\d{2})$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.range "A" "Z")) (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "F") (re.++ (re.* (re.range "A" "Z")) (re.++ (re.++ (str.to_re "12") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))))))))) (str.to_re "")) (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "12") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.* (re.range "A" "Z")) (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "F") (re.* (re.range "A" "Z"))))))))))) (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "12") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)