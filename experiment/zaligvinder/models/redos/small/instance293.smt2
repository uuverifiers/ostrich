;test regex ^(cacheline_[a-zA-Z0-9]{1,50}|cl_[a-zA-Z0-9]{1,50})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re "_") ((_ re.loop 1 50) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))))))))))) (re.++ (str.to_re "c") (re.++ (str.to_re "l") (re.++ (str.to_re "_") ((_ re.loop 1 50) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)