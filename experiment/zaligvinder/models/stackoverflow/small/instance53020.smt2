;test regex 777(?:[0-6]\d{5}|7(?:[0-6]\d{4}|7(?:[0-6]\d{3}|7(?:[0-6]\d{2}|7(?:[0-6]\d|7[0-7])))))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "777") (re.union (re.++ (re.range "0" "6") ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ (str.to_re "7") (re.union (re.++ (re.range "0" "6") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "7") (re.union (re.++ (re.range "0" "6") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "7") (re.union (re.++ (re.range "0" "6") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "7") (re.union (re.++ (re.range "0" "6") (re.range "0" "9")) (re.++ (str.to_re "7") (re.range "0" "7"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)