;test regex ^(?:(?:[1-9][0-9]*(?:(?:.|,)\d{2})?)|(?:0(?:(?:.|,)(?:4[1-9]|[5-9]\d))))?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.opt (re.union (re.++ (re.range "1" "9") (re.++ (re.* (re.range "0" "9")) (re.opt (re.++ (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re ",")) ((_ re.loop 2 2) (re.range "0" "9")))))) (re.++ (str.to_re "0") (re.++ (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re ",")) (re.union (re.++ (str.to_re "4") (re.range "1" "9")) (re.++ (re.range "5" "9") (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)