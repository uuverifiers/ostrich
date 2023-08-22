;test regex "[rRyYaAnN]{1,5}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 1 5) (re.union (str.to_re "r") (re.union (str.to_re "R") (re.union (str.to_re "y") (re.union (str.to_re "Y") (re.union (str.to_re "a") (re.union (str.to_re "A") (re.union (str.to_re "n") (str.to_re "N"))))))))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)