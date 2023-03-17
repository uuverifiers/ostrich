;test regex if (/^[0-9A-Z]{3}\z/ && !/^00[0-2]\z/)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "i") (re.++ (str.to_re "f") (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re "z") (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re "&") (re.++ (str.to_re "&") (re.++ (str.to_re " ") (re.++ (str.to_re "!") (str.to_re "/"))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "00") (re.++ (re.range "0" "2") (re.++ (str.to_re "z") (str.to_re "/")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)