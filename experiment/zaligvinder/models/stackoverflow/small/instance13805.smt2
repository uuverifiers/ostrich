;test regex ^(?:[xywh]=\d+ ){3}[xywh]=\d+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.++ (re.union (str.to_re "x") (re.union (str.to_re "y") (re.union (str.to_re "w") (str.to_re "h")))) (re.++ (str.to_re "=") (re.++ (re.+ (re.range "0" "9")) (str.to_re " "))))) (re.++ (re.union (str.to_re "x") (re.union (str.to_re "y") (re.union (str.to_re "w") (str.to_re "h")))) (re.++ (str.to_re "=") (re.+ (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)