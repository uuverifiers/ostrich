;test regex end\\s+[a-zA-Z]{1}[a-zA-Z_0-9]
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "s")) (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "_") (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)