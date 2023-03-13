;test regex (((0[1-9]{1}|1[0-9]|2[0-9]).(0[1-9]|1[0-2]))|(30.(04|06|09|11))|((30|31).(01|03|05|07|08|10|12))).[0-9]{4}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (re.union (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (str.to_re "1") (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "9"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))))) (re.++ (str.to_re "30") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.union (re.union (re.union (str.to_re "04") (str.to_re "06")) (str.to_re "09")) (str.to_re "11"))))) (re.++ (re.union (str.to_re "30") (str.to_re "31")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "01") (str.to_re "03")) (str.to_re "05")) (str.to_re "07")) (str.to_re "08")) (str.to_re "10")) (str.to_re "12"))))) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 4 4) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)