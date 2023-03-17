;test regex (([@]{1}|[#]{1})[A-Za-z0-9]+)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (str.to_re "@")) ((_ re.loop 1 1) (str.to_re "#"))) (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)