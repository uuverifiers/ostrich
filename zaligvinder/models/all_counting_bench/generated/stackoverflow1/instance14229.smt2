;test regex "\\b0*(2(5[0-5]|[0-4]\\d)|1?\\d{1,2})(\\.0*(2(5[0-5]|[0-4]\\d)|1?\\d{1,2})){3}\\b"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (re.* (str.to_re "0")) (re.++ (re.union (re.++ (str.to_re "2") (re.union (re.++ (str.to_re "5") (re.range "0" "5")) (re.++ (re.range "0" "4") (re.++ (str.to_re "\\") (str.to_re "d"))))) (re.++ (re.opt (str.to_re "1")) (re.++ (str.to_re "\\") ((_ re.loop 1 2) (str.to_re "d"))))) (re.++ ((_ re.loop 3 3) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.* (str.to_re "0")) (re.union (re.++ (str.to_re "2") (re.union (re.++ (str.to_re "5") (re.range "0" "5")) (re.++ (re.range "0" "4") (re.++ (str.to_re "\\") (str.to_re "d"))))) (re.++ (re.opt (str.to_re "1")) (re.++ (str.to_re "\\") ((_ re.loop 1 2) (str.to_re "d"))))))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (str.to_re "\u{22}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)