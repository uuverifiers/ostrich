;test regex ^[A-Y][A-Y][A-Y]{1}\d{1}d{1}d{1}d{1}d{1}[A-Z]{1}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.range "A" "Y") (re.++ (re.range "A" "Y") (re.++ ((_ re.loop 1 1) (re.range "A" "Y")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re "d")) (re.++ ((_ re.loop 1 1) (str.to_re "d")) (re.++ ((_ re.loop 1 1) (str.to_re "d")) (re.++ ((_ re.loop 1 1) (str.to_re "d")) ((_ re.loop 1 1) (re.range "A" "Z")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)