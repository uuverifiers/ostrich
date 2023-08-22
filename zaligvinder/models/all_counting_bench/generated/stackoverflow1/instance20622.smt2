;test regex ^Episode (\d{1,3}) \(Season (\d{1,2})\)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "E") (re.++ (str.to_re "p") (re.++ (str.to_re "i") (re.++ (str.to_re "s") (re.++ (str.to_re "o") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "(") (re.++ (str.to_re "S") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ")"))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)