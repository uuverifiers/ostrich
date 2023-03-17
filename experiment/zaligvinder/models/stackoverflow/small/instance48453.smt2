;test regex \A((\{YY\})?[-_]*(\{MM\})?[-_]*(\{DD\})?[-_]*(\{N{4,8}\})|[A-Za-z])*\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.* (re.union (re.++ (re.opt (re.++ (str.to_re "{") (re.++ (str.to_re "Y") (re.++ (str.to_re "Y") (str.to_re "}"))))) (re.++ (re.* (re.union (str.to_re "-") (str.to_re "_"))) (re.++ (re.opt (re.++ (str.to_re "{") (re.++ (str.to_re "M") (re.++ (str.to_re "M") (str.to_re "}"))))) (re.++ (re.* (re.union (str.to_re "-") (str.to_re "_"))) (re.++ (re.opt (re.++ (str.to_re "{") (re.++ (str.to_re "D") (re.++ (str.to_re "D") (str.to_re "}"))))) (re.++ (re.* (re.union (str.to_re "-") (str.to_re "_"))) (re.++ (str.to_re "{") (re.++ ((_ re.loop 4 8) (str.to_re "N")) (str.to_re "}"))))))))) (re.union (re.range "A" "Z") (re.range "a" "z")))) (str.to_re "z")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)