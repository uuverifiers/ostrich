;test regex ^((0?[0-9]|1[012])([:.][0-9]{2})?(\s?[ap]m)|([01]?[0-9]|2[0-3])([:.][0-9]{2})?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (str.to_re "012"))) (re.++ (re.opt (re.++ (re.union (str.to_re ":") (str.to_re ".")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.union (str.to_re "a") (str.to_re "p")) (str.to_re "m"))))) (re.++ (re.union (re.++ (re.opt (str.to_re "01")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.opt (re.++ (re.union (str.to_re ":") (str.to_re ".")) ((_ re.loop 2 2) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)