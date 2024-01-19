;test regex [&?]validVehicle=(?:.*?%3a){3}(.*?)%3a
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "&") (str.to_re "?")) (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "V") (re.++ (str.to_re "e") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ ((_ re.loop 3 3) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "%") (re.++ (str.to_re "3") (str.to_re "a"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "%") (re.++ (str.to_re "3") (str.to_re "a")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)