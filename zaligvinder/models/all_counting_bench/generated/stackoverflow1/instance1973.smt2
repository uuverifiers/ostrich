;test regex ^(GIR 0AA|[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKPS-UW])[0-9][ABD-HJLNP-UW-Z]{2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (str.to_re "G") (re.++ (str.to_re "I") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "0") (re.++ (str.to_re "A") (str.to_re "A"))))))) (re.++ (re.union (re.range "A" "P") (re.union (re.range "R" "U") (re.union (str.to_re "W") (re.union (str.to_re "Y") (str.to_re "Z"))))) (re.++ (re.union (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.union (re.++ (re.union (re.range "A" "H") (re.range "K" "Y")) (re.range "0" "9")) (re.++ (re.union (re.range "A" "H") (re.range "K" "Y")) (re.++ (re.range "0" "9") (re.union (re.range "0" "9") (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "E") (re.union (str.to_re "H") (re.union (str.to_re "M") (re.union (str.to_re "N") (re.union (str.to_re "P") (re.union (str.to_re "R") (re.range "V" "Y")))))))))))))) (re.++ (re.range "0" "9") (re.union (re.range "A" "H") (re.union (str.to_re "J") (re.union (str.to_re "K") (re.union (str.to_re "P") (re.union (re.range "S" "U") (str.to_re "W")))))))) (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (re.range "D" "H") (re.union (str.to_re "J") (re.union (str.to_re "L") (re.union (str.to_re "N") (re.union (re.range "P" "U") (re.range "W" "Z")))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)