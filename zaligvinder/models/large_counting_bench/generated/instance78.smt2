;test regex ^\n*[vV][rR][fF][yY][^\n]{255,}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (str.to_re "\u{0a}")) (re.++ (re.union (str.to_re "v") (str.to_re "V")) (re.++ (re.union (str.to_re "r") (str.to_re "R")) (re.++ (re.union (str.to_re "f") (str.to_re "F")) (re.++ (re.union (str.to_re "y") (str.to_re "Y")) (re.++ (re.* (re.diff re.allchar (str.to_re "\u{0a}"))) ((_ re.loop 255 255) (re.diff re.allchar (str.to_re "\u{0a}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)