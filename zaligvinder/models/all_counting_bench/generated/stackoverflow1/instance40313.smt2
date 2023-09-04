;test regex ^(?:\d{1,16}|(?:\n|\r|[ -Z]|_|[a-z]|\xC2\xA0|\xCE\xA9){1,11})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union ((_ re.loop 1 16) (re.range "0" "9")) ((_ re.loop 1 11) (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}")) (re.range " " "Z")) (str.to_re "_")) (re.range "a" "z")) (re.++ (str.to_re "\u{c2}") (str.to_re "\u{a0}"))) (re.++ (str.to_re "\u{ce}") (str.to_re "\u{a9}")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)