;test regex [BCGRYWbcgryw]{4}\[\d\]
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (str.to_re "B") (re.union (str.to_re "C") (re.union (str.to_re "G") (re.union (str.to_re "R") (re.union (str.to_re "Y") (re.union (str.to_re "W") (re.union (str.to_re "b") (re.union (str.to_re "c") (re.union (str.to_re "g") (re.union (str.to_re "r") (re.union (str.to_re "y") (str.to_re "w"))))))))))))) (re.++ (str.to_re "[") (re.++ (re.range "0" "9") (str.to_re "]"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)