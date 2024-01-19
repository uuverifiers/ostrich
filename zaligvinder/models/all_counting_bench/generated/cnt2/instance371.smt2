;test regex identityId:.*[0-9a-z]{64}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "y") (re.++ (str.to_re "I") (re.++ (str.to_re "d") (re.++ (str.to_re ":") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 64 64) (re.union (re.range "0" "9") (re.range "a" "z")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)