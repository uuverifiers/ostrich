;test regex [test1_ab_pls_]+\d{8}(.csv)
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "t") (re.union (str.to_re "e") (re.union (str.to_re "s") (re.union (str.to_re "t") (re.union (str.to_re "1") (re.union (str.to_re "_") (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (str.to_re "_") (re.union (str.to_re "p") (re.union (str.to_re "l") (re.union (str.to_re "s") (str.to_re "_")))))))))))))) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "s") (str.to_re "v"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)