;test regex pwd=(\!|\%21)CRYPT(\!|\%21)[A-Z0-9]{512}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "p") (re.++ (str.to_re "w") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.++ (re.union (str.to_re "!") (re.++ (str.to_re "%") (str.to_re "21"))) (re.++ (str.to_re "C") (re.++ (str.to_re "R") (re.++ (str.to_re "Y") (re.++ (str.to_re "P") (re.++ (str.to_re "T") (re.++ (re.union (str.to_re "!") (re.++ (str.to_re "%") (str.to_re "21"))) ((_ re.loop 512 512) (re.union (re.range "A" "Z") (re.range "0" "9"))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)