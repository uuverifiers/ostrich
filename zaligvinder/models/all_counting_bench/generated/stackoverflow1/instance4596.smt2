;test regex [\d]{1,}.(thumbnail|medium|large).[\w]+
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.union (re.union (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (str.to_re "b") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (str.to_re "l"))))))))) (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "u") (str.to_re "m"))))))) (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "g") (str.to_re "e")))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)