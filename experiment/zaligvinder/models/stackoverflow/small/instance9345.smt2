;test regex s/(\d{1,3}\.\d{1,3})\.233(\.\d{1,3})/$1.234$2/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (str.to_re "233") (re.++ (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "/"))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re "234"))))) (re.++ (str.to_re "") (re.++ (str.to_re "2") (str.to_re "/"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)