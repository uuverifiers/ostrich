;test regex [A-Z1-9]{0,30}?(?:[A-Z][1-9])?
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 30) (re.union (re.range "A" "Z") (re.range "1" "9"))) (re.opt (re.++ (re.range "A" "Z") (re.range "1" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)