;test regex ([0-8]?\d[0-5]?\d[0-5]?\d|900000)[NS]([0-1]?[0-7]?\d[0-5]?\d[0-5]?\d|1800000)[EW]\d{3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "8")) (re.++ (re.range "0" "9") (re.++ (re.opt (re.range "0" "5")) (re.++ (re.range "0" "9") (re.++ (re.opt (re.range "0" "5")) (re.range "0" "9")))))) (str.to_re "900000")) (re.++ (re.union (str.to_re "N") (str.to_re "S")) (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.++ (re.opt (re.range "0" "7")) (re.++ (re.range "0" "9") (re.++ (re.opt (re.range "0" "5")) (re.++ (re.range "0" "9") (re.++ (re.opt (re.range "0" "5")) (re.range "0" "9"))))))) (str.to_re "1800000")) (re.++ (re.union (str.to_re "E") (str.to_re "W")) ((_ re.loop 3 3) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)