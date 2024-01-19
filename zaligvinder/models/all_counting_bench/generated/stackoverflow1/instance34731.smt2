;test regex abcdef.*g[0abc]{0,5}hi
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "g") (re.++ ((_ re.loop 0 5) (re.union (str.to_re "0") (re.union (str.to_re "a") (re.union (str.to_re "b") (str.to_re "c"))))) (re.++ (str.to_re "h") (str.to_re "i")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)