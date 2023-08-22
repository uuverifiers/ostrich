;test regex [^a-z0-9& ]|&(#[0-9]{2,3})?
(declare-const X String)
(assert (str.in_re X (re.union (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.inter (re.diff re.allchar (str.to_re "&")) (re.diff re.allchar (str.to_re " "))))) (re.++ (str.to_re "&") (re.opt (re.++ (str.to_re "#") ((_ re.loop 2 3) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)