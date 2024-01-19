;test regex ~[a-z]{2}[\d|\,]{6}[A-M]
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "~") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ ((_ re.loop 6 6) (re.union (re.range "0" "9") (re.union (str.to_re "|") (str.to_re ",")))) (re.range "A" "M"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)