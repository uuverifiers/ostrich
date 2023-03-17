;test regex (#[\d]{1,3}.[\d]{6},E,[\d]{2}.[\d]{6},N,[\d]{1}.[\d]{2},[\d]{1}.[\d]{2}#[\d]{6}#[\d]{6})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "#") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 6 6) (re.range "0" "9"))))) (re.++ (str.to_re ",") (str.to_re "E"))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 6 6) (re.range "0" "9")))))) (re.++ (str.to_re ",") (str.to_re "N"))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 2 2) (re.range "0" "9")))))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "#") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re "#") ((_ re.loop 6 6) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)