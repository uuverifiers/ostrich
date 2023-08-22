;test regex [-_A-Za-z0-9]{21}[AQgw]
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 21 21) (re.union (str.to_re "-") (re.union (str.to_re "_") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.union (str.to_re "A") (re.union (str.to_re "Q") (re.union (str.to_re "g") (str.to_re "w")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)