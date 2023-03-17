;test regex [^A-Z,a-z]*(?:[A-Z,a-z][^A-Z,a-z]*){0,5}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (str.to_re ",")) (re.diff re.allchar (re.range "a" "z"))))) ((_ re.loop 0 5) (re.++ (re.union (re.range "A" "Z") (re.union (str.to_re ",") (re.range "a" "z"))) (re.* (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (str.to_re ",")) (re.diff re.allchar (re.range "a" "z"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)