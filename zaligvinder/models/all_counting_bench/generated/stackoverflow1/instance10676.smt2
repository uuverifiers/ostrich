;test regex pat="^(lo){3}"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "=") (str.to_re "\u{22}"))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.++ (str.to_re "l") (str.to_re "o"))) (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)