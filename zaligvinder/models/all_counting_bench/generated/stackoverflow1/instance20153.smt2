;test regex <(AET|BUS)>_{1}([^_]){1,}_{1}(.){1,}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "E") (str.to_re "T"))) (re.++ (str.to_re "B") (re.++ (str.to_re "U") (str.to_re "S")))) (re.++ (str.to_re ">") (re.++ ((_ re.loop 1 1) (str.to_re "_")) (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "_"))) ((_ re.loop 1 1) (re.diff re.allchar (str.to_re "_")))) (re.++ ((_ re.loop 1 1) (str.to_re "_")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 1 1) (re.diff re.allchar (str.to_re "\n"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)