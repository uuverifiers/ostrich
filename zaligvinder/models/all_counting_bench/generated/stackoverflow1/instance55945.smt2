;test regex \\frac\{\[?([a-zA-Z1-9\+]{2,})\]?\}\{\[?([a-zA-Z1-9\+]{2,})\]?\}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\\") (re.++ (str.to_re "f") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "{") (re.++ (re.opt (str.to_re "[")) (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "1" "9") (str.to_re "+"))))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "1" "9") (str.to_re "+")))))) (re.++ (re.opt (str.to_re "]")) (re.++ (str.to_re "}") (re.++ (str.to_re "{") (re.++ (re.opt (str.to_re "[")) (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "1" "9") (str.to_re "+"))))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "1" "9") (str.to_re "+")))))) (re.++ (re.opt (str.to_re "]")) (str.to_re "}")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)