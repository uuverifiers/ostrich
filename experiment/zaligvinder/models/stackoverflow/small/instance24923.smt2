;test regex TN-(In|Te|Yo|Et)-([A-Z]{2}-){2}(19[7-9][0-9]|200[0-9]|201[0-2])-[0-9]{1,4}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "T") (re.++ (str.to_re "N") (re.++ (str.to_re "-") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "I") (str.to_re "n")) (re.++ (str.to_re "T") (str.to_re "e"))) (re.++ (str.to_re "Y") (str.to_re "o"))) (re.++ (str.to_re "E") (str.to_re "t"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "-"))) (re.++ (re.union (re.union (re.++ (str.to_re "19") (re.++ (re.range "7" "9") (re.range "0" "9"))) (re.++ (str.to_re "200") (re.range "0" "9"))) (re.++ (str.to_re "201") (re.range "0" "2"))) (re.++ (str.to_re "-") ((_ re.loop 1 4) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)