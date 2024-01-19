;test regex [01]?[- .]?\(?[2-9]\d{2}\)?[- .]?\d{3}[- .]?\d{4}(?:i.{0,3}x?.{0,9})(\d{1,5})
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "01")) (re.++ (re.opt (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re ".")))) (re.++ (re.opt (str.to_re "(")) (re.++ (re.range "2" "9") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.opt (str.to_re ")")) (re.++ (re.opt (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re ".")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re ".")))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (re.++ (str.to_re "i") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.opt (str.to_re "x")) ((_ re.loop 0 9) (re.diff re.allchar (str.to_re "\n")))))) ((_ re.loop 1 5) (re.range "0" "9")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)