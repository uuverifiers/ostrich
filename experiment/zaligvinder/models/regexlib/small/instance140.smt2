;test regex ^[ISBN]{4}[ ]{0,1}[0-9]{1}[-]{1}[0-9]{3}[-]{1}[0-9]{5}[-]{1}[0-9]{0,1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.union (str.to_re "I") (re.union (str.to_re "S") (re.union (str.to_re "B") (str.to_re "N"))))) (re.++ ((_ re.loop 0 1) (str.to_re " ")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re "-")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re "-")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re "-")) ((_ re.loop 0 1) (re.range "0" "9"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)