;test regex (\d{1,3}\s(\d{3}\s)*\d{3}(\,\d{1,3})?|\d{1,3}\,\d{1,3})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") ((_ re.loop 1 3) (re.range "0" "9")))))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ",") ((_ re.loop 1 3) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)