;test regex \D(.*[\D]){0,1}
(declare-const X String)
(assert (str.in_re X (re.++ (re.diff re.allchar (re.range "0" "9")) ((_ re.loop 0 1) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.diff re.allchar (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)