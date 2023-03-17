;test regex ^\/pp\/dc\/dc[123]\/h([1-9]{1,2}|100)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re "p") (re.++ (str.to_re "p") (re.++ (str.to_re "/") (re.++ (str.to_re "d") (re.++ (str.to_re "c") (re.++ (str.to_re "/") (re.++ (str.to_re "d") (re.++ (str.to_re "c") (re.++ (str.to_re "123") (re.++ (str.to_re "/") (re.++ (str.to_re "h") (re.union ((_ re.loop 1 2) (re.range "1" "9")) (str.to_re "100"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)