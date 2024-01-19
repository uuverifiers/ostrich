;test regex ^(?:[1-9]\d?|[12]\d{2}|3[0-5]\d|36[0-5])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (re.range "1" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "12") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "3") (re.++ (re.range "0" "5") (re.range "0" "9")))) (re.++ (str.to_re "36") (re.range "0" "5")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)