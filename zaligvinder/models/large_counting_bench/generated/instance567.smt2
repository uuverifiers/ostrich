;test regex (?:ATA|ATT)[ATCGN]{144,16563}(?:AGA|AGG|TAA|TAG)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "T") (str.to_re "A"))) (re.++ (str.to_re "A") (re.++ (str.to_re "T") (str.to_re "T")))) (re.++ ((_ re.loop 144 16563) (re.union (str.to_re "A") (re.union (str.to_re "T") (re.union (str.to_re "C") (re.union (str.to_re "G") (str.to_re "N")))))) (re.union (re.union (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "G") (str.to_re "A"))) (re.++ (str.to_re "A") (re.++ (str.to_re "G") (str.to_re "G")))) (re.++ (str.to_re "T") (re.++ (str.to_re "A") (str.to_re "A")))) (re.++ (str.to_re "T") (re.++ (str.to_re "A") (str.to_re "G"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)