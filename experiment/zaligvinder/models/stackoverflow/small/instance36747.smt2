;test regex CAS\*(OA|PR|CR|CO)\*[^0-9A-Z]+?\*[-]?[\d]+\.?[\d]{0,2}~
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "C") (re.++ (str.to_re "A") (re.++ (str.to_re "S") (re.++ (str.to_re "*") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "O") (str.to_re "A")) (re.++ (str.to_re "P") (str.to_re "R"))) (re.++ (str.to_re "C") (str.to_re "R"))) (re.++ (str.to_re "C") (str.to_re "O"))) (re.++ (str.to_re "*") (re.++ (re.+ (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (re.range "A" "Z")))) (re.++ (str.to_re "*") (re.++ (re.opt (str.to_re "-")) (re.++ (re.+ (re.range "0" "9")) (re.++ (re.opt (str.to_re ".")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "~")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)