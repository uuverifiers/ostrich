;test regex \d{1,4}[wW](\d|[0-4]\d|5[0123])
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (re.union (str.to_re "w") (str.to_re "W")) (re.union (re.union (re.range "0" "9") (re.++ (re.range "0" "4") (re.range "0" "9"))) (re.++ (str.to_re "5") (str.to_re "0123")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)