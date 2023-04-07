;test regex ^([MmCcFf]\D*\d{1}\s*){1,3}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 1 3) (re.++ (re.union (str.to_re "M") (re.union (str.to_re "m") (re.union (str.to_re "C") (re.union (str.to_re "c") (re.union (str.to_re "F") (str.to_re "f")))))) (re.++ (re.* (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)