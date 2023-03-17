;test regex .fw-[0-9](.\w{0,2})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "f") (re.++ (str.to_re "w") (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.opt (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 0 2) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)