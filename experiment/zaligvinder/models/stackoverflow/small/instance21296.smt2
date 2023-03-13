;test regex ^(\*{3}.*\n{2})(([a-zA-Z])*([0-9]*)\n{2})*(END)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 3 3) (str.to_re "*")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 2 2) (str.to_re "\u{0a}")))) (re.++ (re.* (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (str.to_re "\u{0a}"))))) (re.++ (str.to_re "E") (re.++ (str.to_re "N") (str.to_re "D")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)