;test regex '\\([^0][0-9A-Fa-f]{3}|[0-9A-Fa-f][^0][0-9A-Fa-f]{2})'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\\") (re.++ (re.union (re.++ (re.diff re.allchar (str.to_re "0")) ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f"))))) (re.++ (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f"))) (re.++ (re.diff re.allchar (str.to_re "0")) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f"))))))) (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)