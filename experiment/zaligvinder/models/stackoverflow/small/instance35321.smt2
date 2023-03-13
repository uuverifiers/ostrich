;test regex KeywordB:\t456\n|\G\t(?:(\d{2,})|\d)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "K") (re.++ (str.to_re "e") (re.++ (str.to_re "y") (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "d") (re.++ (str.to_re "B") (re.++ (str.to_re ":") (re.++ (str.to_re "\u{09}") (re.++ (str.to_re "456") (str.to_re "\u{0a}")))))))))))) (re.++ (str.to_re "G") (re.++ (str.to_re "\u{09}") (re.union (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)