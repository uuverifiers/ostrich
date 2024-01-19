;test regex ^0x(?:[0-9A-Fa-f]{4096})+^0x(?:[0-9A-Fa-f]{32})+(?:[0-9A-Fa-f]{2})+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ (str.to_re "x") (re.+ ((_ re.loop 4096 4096) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f")))))))) (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ (str.to_re "x") (re.++ (re.+ ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f"))))) (re.+ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)