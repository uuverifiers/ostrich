;test regex REGEXP_EXTRACT(column,'([A-Z]\\d{7})',1)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "P") (re.++ (str.to_re "_") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re "A") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (re.++ (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (str.to_re "n")))))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (re.++ (re.++ (re.range "A" "Z") (re.++ (str.to_re "\\") ((_ re.loop 7 7) (str.to_re "d")))) (str.to_re "\u{27}"))))) (re.++ (str.to_re ",") (str.to_re "1")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)