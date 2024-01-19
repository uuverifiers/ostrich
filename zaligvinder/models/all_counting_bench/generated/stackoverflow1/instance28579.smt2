;test regex Town ([0-9]{1,2}[\D])|Range ([0-9]{1,2}[\D])
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "T") (re.++ (str.to_re "o") (re.++ (str.to_re "w") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.diff re.allchar (re.range "0" "9")))))))) (re.++ (str.to_re "R") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.diff re.allchar (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)