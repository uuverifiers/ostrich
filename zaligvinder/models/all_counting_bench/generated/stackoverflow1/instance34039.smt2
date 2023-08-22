;test regex "8abba778_a2012".matches("^[a-zA-Z0-9]{8}_[a-z]\\d{4}$");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "8") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "778") (re.++ (str.to_re "_") (re.++ (str.to_re "a") (re.++ (str.to_re "2012") (re.++ (str.to_re "\u{22}") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (str.to_re "_") (re.++ (re.range "a" "z") (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d")))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))) (str.to_re ";")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)