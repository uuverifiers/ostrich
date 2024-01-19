;test regex /info\.php\?id=[0-9]{3}&sent=ok
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "h") (re.++ (str.to_re "p") (re.++ (str.to_re "?") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "&") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "=") (re.++ (str.to_re "o") (str.to_re "k"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)