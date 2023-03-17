;test regex [a-z\d]{6}(?:_[a-f\d]{32}){2}(?:_\d+){3}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "_") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))))) ((_ re.loop 3 3) (re.++ (str.to_re "_") (re.+ (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)