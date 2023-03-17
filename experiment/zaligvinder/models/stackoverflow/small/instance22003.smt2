;test regex ^[A-Z]{3}(1[A-Z]*[ABC]|2[A-Z]*[DEF]|3[A-Z]*[GHI])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.union (re.union (re.++ (str.to_re "1") (re.++ (re.* (re.range "A" "Z")) (re.union (str.to_re "A") (re.union (str.to_re "B") (str.to_re "C"))))) (re.++ (str.to_re "2") (re.++ (re.* (re.range "A" "Z")) (re.union (str.to_re "D") (re.union (str.to_re "E") (str.to_re "F")))))) (re.++ (str.to_re "3") (re.++ (re.* (re.range "A" "Z")) (re.union (str.to_re "G") (re.union (str.to_re "H") (str.to_re "I")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)