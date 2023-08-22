;test regex (http:\/\/)?(www\.)?(example\.com\/)[a-zA-Z]{0,}(\/)(id-)[0-9]{1,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (str.to_re ":") (re.++ (str.to_re "/") (str.to_re "/")))))))) (re.++ (re.opt (re.++ (str.to_re "w") (re.++ (str.to_re "w") (re.++ (str.to_re "w") (str.to_re "."))))) (re.++ (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (str.to_re "/")))))))))))) (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 0 0) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re "/") (re.++ (re.++ (str.to_re "i") (re.++ (str.to_re "d") (str.to_re "-"))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)