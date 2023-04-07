;test regex INGRESSCOOKIE=[0-9a-f]{40}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "G") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "S") (re.++ (str.to_re "S") (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "O") (re.++ (str.to_re "K") (re.++ (str.to_re "I") (re.++ (str.to_re "E") (re.++ (str.to_re "=") ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "a" "f")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)