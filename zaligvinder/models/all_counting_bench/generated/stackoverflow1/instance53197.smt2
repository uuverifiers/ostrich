;test regex (((0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-(19|20)\d\d)\s((\d{2}:?){3})|(\d+\.?\d+))
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "12") (re.range "0" "9"))) (re.++ (str.to_re "3") (str.to_re "01"))) (re.++ (str.to_re "-") (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (str.to_re "012"))) (re.++ (str.to_re "-") (re.++ (re.union (str.to_re "19") (str.to_re "20")) (re.++ (re.range "0" "9") (re.range "0" "9"))))))) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) ((_ re.loop 3 3) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ":")))))) (re.++ (re.+ (re.range "0" "9")) (re.++ (re.opt (str.to_re ".")) (re.+ (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)