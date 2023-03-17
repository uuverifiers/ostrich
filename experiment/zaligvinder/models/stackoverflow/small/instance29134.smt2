;test regex match("^(?:\d{3}|ACCOUNT)(.)")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.union ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "A") (re.++ (str.to_re "C") (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "U") (re.++ (str.to_re "N") (str.to_re "T")))))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{22}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)