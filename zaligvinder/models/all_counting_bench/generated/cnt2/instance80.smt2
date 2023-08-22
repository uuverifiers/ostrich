;test regex ^\n*[eE][xX][pP][nN][^\n]{255,}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (str.to_re "\u{0a}")) (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.++ (re.union (str.to_re "x") (str.to_re "X")) (re.++ (re.union (str.to_re "p") (str.to_re "P")) (re.++ (re.union (str.to_re "n") (str.to_re "N")) (re.++ (re.* (re.diff re.allchar (str.to_re "\u{0a}"))) ((_ re.loop 255 255) (re.diff re.allchar (str.to_re "\u{0a}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)