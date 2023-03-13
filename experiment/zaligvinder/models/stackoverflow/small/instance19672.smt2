;test regex ^1[01456](16|3\d|6\d|9\d|\d\d)\d{5}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re "01456") (re.++ (re.union (re.union (re.union (re.union (str.to_re "16") (re.++ (str.to_re "3") (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "9"))) (re.++ (str.to_re "9") (re.range "0" "9"))) (re.++ (re.range "0" "9") (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)