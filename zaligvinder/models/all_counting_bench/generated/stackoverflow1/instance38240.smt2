;test regex ^\d{6}.\d{3} : Send.*35=AE.*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (str.to_re "S") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "35") (re.++ (str.to_re "=") (re.++ (str.to_re "A") (re.++ (str.to_re "E") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)