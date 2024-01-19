;test regex "[ACGT]{1,12000}(AAC)[AG]{2,5}[ACGT]{2,5}(CTGTGTA)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 1 12000) (re.union (str.to_re "A") (re.union (str.to_re "C") (re.union (str.to_re "G") (str.to_re "T"))))) (re.++ (re.++ (str.to_re "A") (re.++ (str.to_re "A") (str.to_re "C"))) (re.++ ((_ re.loop 2 5) (re.union (str.to_re "A") (str.to_re "G"))) (re.++ ((_ re.loop 2 5) (re.union (str.to_re "A") (re.union (str.to_re "C") (re.union (str.to_re "G") (str.to_re "T"))))) (re.++ (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re "G") (re.++ (str.to_re "T") (re.++ (str.to_re "G") (re.++ (str.to_re "T") (str.to_re "A"))))))) (str.to_re "\u{22}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)