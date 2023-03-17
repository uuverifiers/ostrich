;test regex ATG(?:[ATGC]{3}){13,}(?:TAG|TAA|TGA)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "G") (re.++ (re.++ (re.* ((_ re.loop 3 3) (re.union (str.to_re "A") (re.union (str.to_re "T") (re.union (str.to_re "G") (str.to_re "C")))))) ((_ re.loop 13 13) ((_ re.loop 3 3) (re.union (str.to_re "A") (re.union (str.to_re "T") (re.union (str.to_re "G") (str.to_re "C"))))))) (re.union (re.union (re.++ (str.to_re "T") (re.++ (str.to_re "A") (str.to_re "G"))) (re.++ (str.to_re "T") (re.++ (str.to_re "A") (str.to_re "A")))) (re.++ (str.to_re "T") (re.++ (str.to_re "G") (str.to_re "A"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)