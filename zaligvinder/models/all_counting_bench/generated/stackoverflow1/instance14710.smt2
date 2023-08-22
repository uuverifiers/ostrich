;test regex ^6[12][0-9]{3}(J|CJ)[0-9]{4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "6") (re.++ (str.to_re "12") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.union (str.to_re "J") (re.++ (str.to_re "C") (str.to_re "J"))) ((_ re.loop 4 4) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)