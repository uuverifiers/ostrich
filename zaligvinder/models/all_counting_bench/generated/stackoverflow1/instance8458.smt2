;test regex [VERSION_NUMBER][0-9A-F]{3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "V") (re.union (str.to_re "E") (re.union (str.to_re "R") (re.union (str.to_re "S") (re.union (str.to_re "I") (re.union (str.to_re "O") (re.union (str.to_re "N") (re.union (str.to_re "_") (re.union (str.to_re "N") (re.union (str.to_re "U") (re.union (str.to_re "M") (re.union (str.to_re "B") (re.union (str.to_re "E") (str.to_re "R")))))))))))))) ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "F"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)