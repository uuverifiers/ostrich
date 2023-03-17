;test regex Lyra([A-Za-z0-9]{3,6})(\\d{8}).*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "L") (re.++ (str.to_re "y") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ ((_ re.loop 3 6) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 8 8) (str.to_re "d"))) (re.* (re.diff re.allchar (str.to_re "\n")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)