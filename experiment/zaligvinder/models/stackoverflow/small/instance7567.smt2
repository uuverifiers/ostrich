;test regex ^[+#*\(\)\[\]]*([0-9][ ext+-pw#*\(\)\[\]]*){6,45}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.union (str.to_re "+") (re.union (str.to_re "#") (re.union (str.to_re "*") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "[") (str.to_re "]")))))))) ((_ re.loop 6 45) (re.++ (re.range "0" "9") (re.* (re.union (str.to_re " ") (re.union (str.to_re "e") (re.union (str.to_re "x") (re.union (str.to_re "t") (re.union (str.to_re "+") (re.union (str.to_re "-") (re.union (str.to_re "p") (re.union (str.to_re "w") (re.union (str.to_re "#") (re.union (str.to_re "*") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "[") (str.to_re "]"))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)