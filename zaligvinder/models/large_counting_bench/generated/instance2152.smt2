;test regex ^[^-][a-z0-9-]{0,63}[^-](\.[a-z]{0,9})*(;port=[0-9]{2,6})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.diff re.allchar (str.to_re "-")) (re.++ ((_ re.loop 0 63) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ (re.diff re.allchar (str.to_re "-")) (re.++ (re.* (re.++ (str.to_re ".") ((_ re.loop 0 9) (re.range "a" "z")))) (re.opt (re.++ (str.to_re ";") (re.++ (str.to_re "p") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "t") (re.++ (str.to_re "=") ((_ re.loop 2 6) (re.range "0" "9")))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)