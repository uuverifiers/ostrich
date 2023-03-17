;test regex [&?]{1}validVehicle[=]{1}[^&]*[%3A]{1}([^%&]+)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "&") (str.to_re "?"))) (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "V") (re.++ (str.to_re "e") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ ((_ re.loop 1 1) (str.to_re "=")) (re.++ (re.* (re.diff re.allchar (str.to_re "&"))) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "%") (re.union (str.to_re "3") (str.to_re "A")))) (re.+ (re.inter (re.diff re.allchar (str.to_re "%")) (re.diff re.allchar (str.to_re "&"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)