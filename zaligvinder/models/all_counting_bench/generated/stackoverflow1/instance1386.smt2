;test regex .*/([A-Z0-9_]{1,9}?)(_O|_?Full).*[.]cmd
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 9) (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.++ (re.union (re.++ (str.to_re "_") (str.to_re "O")) (re.++ (re.opt (str.to_re "_")) (re.++ (str.to_re "F") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (str.to_re "l")))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "m") (str.to_re "d")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)