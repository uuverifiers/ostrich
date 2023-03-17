;test regex ^\d{4,}$|^[3-9]\d{2}$|^2[5-9]\d$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.range "3" "9") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "2") (re.++ (re.range "5" "9") (re.range "0" "9")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)