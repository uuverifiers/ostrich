;test regex [ACGT]*((ATG)(([ACGT]){3})+(TAA|TAG|TGA))[ACGT]*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "A") (re.union (str.to_re "C") (re.union (str.to_re "G") (str.to_re "T"))))) (re.++ (re.++ (re.++ (str.to_re "A") (re.++ (str.to_re "T") (str.to_re "G"))) (re.++ (re.+ ((_ re.loop 3 3) (re.union (str.to_re "A") (re.union (str.to_re "C") (re.union (str.to_re "G") (str.to_re "T")))))) (re.union (re.union (re.++ (str.to_re "T") (re.++ (str.to_re "A") (str.to_re "A"))) (re.++ (str.to_re "T") (re.++ (str.to_re "A") (str.to_re "G")))) (re.++ (str.to_re "T") (re.++ (str.to_re "G") (str.to_re "A")))))) (re.* (re.union (str.to_re "A") (re.union (str.to_re "C") (re.union (str.to_re "G") (str.to_re "T")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)