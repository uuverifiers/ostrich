;test regex (?:col-lg-offset-)[0-9]{1,2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "-") (re.++ (str.to_re "l") (re.++ (str.to_re "g") (re.++ (str.to_re "-") (re.++ (str.to_re "o") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (str.to_re "-")))))))))))))) ((_ re.loop 1 2) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)