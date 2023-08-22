;test regex ^(?:pci[0-9a-f]{4}_[0-9a-f]{2}_[0-9a-f]{2}_[0-9a-f]{1}|bus\d+port\d+)(?:-\d+)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "p") (re.++ (str.to_re "c") (re.++ (str.to_re "i") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "_") ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "a" "f")))))))))))) (re.++ (str.to_re "b") (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "p") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "t") (re.+ (re.range "0" "9"))))))))))) (re.opt (re.++ (str.to_re "-") (re.+ (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)