;test regex .*id=(\d{1,3}\D|[1-4]\d{3}\D)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.diff re.allchar (re.range "0" "9"))) (re.++ (re.range "1" "4") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.diff re.allchar (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)