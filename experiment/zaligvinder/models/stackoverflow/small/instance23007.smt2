;test regex ^09[1-9]{2}(^0[1-9]{1}[0-9]{6}|[1-9]{1}[0-9]{7})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "09") (re.++ ((_ re.loop 2 2) (re.range "1" "9")) (re.union (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 6 6) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 7 7) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)