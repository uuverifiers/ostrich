;test regex C[AG]{7,10}[ACGT]{5,8}ATGC
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "C") (re.++ ((_ re.loop 7 10) (re.union (str.to_re "A") (str.to_re "G"))) (re.++ ((_ re.loop 5 8) (re.union (str.to_re "A") (re.union (str.to_re "C") (re.union (str.to_re "G") (str.to_re "T"))))) (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "G") (str.to_re "C")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)