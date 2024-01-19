;test regex ([\d]{5}(?:[^\d]{5})+?Target Word)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.+ ((_ re.loop 5 5) (re.diff re.allchar (re.range "0" "9")))) (re.++ (str.to_re "T") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "W") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re "d")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)