;test regex (?:TestCaseID: )([0-9]{5}, [0-9])
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "T") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "C") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "I") (re.++ (str.to_re "D") (re.++ (str.to_re ":") (str.to_re " ")))))))))))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)