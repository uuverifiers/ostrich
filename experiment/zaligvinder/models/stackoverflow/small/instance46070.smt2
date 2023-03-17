;test regex ^(.{0,3}$|[^m]|m([^p]|p([^e]|e([^g])))).*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "")) (re.diff re.allchar (str.to_re "m"))) (re.++ (str.to_re "m") (re.union (re.diff re.allchar (str.to_re "p")) (re.++ (str.to_re "p") (re.union (re.diff re.allchar (str.to_re "e")) (re.++ (str.to_re "e") (re.diff re.allchar (str.to_re "g")))))))) (re.* (re.diff re.allchar (str.to_re "\n"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)