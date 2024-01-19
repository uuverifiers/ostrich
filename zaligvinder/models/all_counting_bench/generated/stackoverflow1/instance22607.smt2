;test regex ((\d{3})\W+(SSN))|((SSN)\W+(\d{3}))
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.+ (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_")))))) (re.++ (str.to_re "S") (re.++ (str.to_re "S") (str.to_re "N"))))) (re.++ (re.++ (str.to_re "S") (re.++ (str.to_re "S") (str.to_re "N"))) (re.++ (re.+ (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_")))))) ((_ re.loop 3 3) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)