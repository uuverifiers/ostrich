;test regex ^[3|4|5|6]([0-9]{15}$|[0-9]{12}$|[0-9]{13}$|[0-9]{14}$)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (str.to_re "3") (re.union (str.to_re "|") (re.union (str.to_re "4") (re.union (str.to_re "|") (re.union (str.to_re "5") (re.union (str.to_re "|") (str.to_re "6"))))))) (re.union (re.union (re.union (re.++ ((_ re.loop 15 15) (re.range "0" "9")) (str.to_re "")) (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re ""))) (re.++ ((_ re.loop 13 13) (re.range "0" "9")) (str.to_re ""))) (re.++ ((_ re.loop 14 14) (re.range "0" "9")) (str.to_re "")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)