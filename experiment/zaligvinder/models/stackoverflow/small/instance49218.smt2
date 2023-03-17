;test regex ([a-z-]+\\.[a-z]{2,6})$ [NC]
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.+ (re.union (re.range "a" "z") (str.to_re "-"))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 2 6) (re.range "a" "z"))))) (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.union (str.to_re "N") (str.to_re "C")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)