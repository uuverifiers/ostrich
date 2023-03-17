;test regex ^((\+316|06|00316){1}\\s?-?\s?[1-9]{1}[0-9]{7})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (re.union (re.++ (str.to_re "+") (str.to_re "316")) (str.to_re "06")) (str.to_re "00316"))) (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) (re.++ (re.opt (str.to_re "-")) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 7 7) (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)