;test regex '[Pp][Aa][Nn][Tt][Oo][Nn][Ee] [0-9]{3}.*'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (re.union (str.to_re "P") (str.to_re "p")) (re.++ (re.union (str.to_re "A") (str.to_re "a")) (re.++ (re.union (str.to_re "N") (str.to_re "n")) (re.++ (re.union (str.to_re "T") (str.to_re "t")) (re.++ (re.union (str.to_re "O") (str.to_re "o")) (re.++ (re.union (str.to_re "N") (str.to_re "n")) (re.++ (re.union (str.to_re "E") (str.to_re "e")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{27}"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)