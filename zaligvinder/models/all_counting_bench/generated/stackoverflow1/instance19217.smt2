;test regex (?:LU|Local|Lodge|Council|LL)(\d{1,6})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "L") (str.to_re "U")) (re.++ (str.to_re "L") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (str.to_re "l")))))) (re.++ (str.to_re "L") (re.++ (str.to_re "o") (re.++ (str.to_re "d") (re.++ (str.to_re "g") (str.to_re "e")))))) (re.++ (str.to_re "C") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.++ (str.to_re "c") (re.++ (str.to_re "i") (str.to_re "l")))))))) (re.++ (str.to_re "L") (str.to_re "L"))) ((_ re.loop 1 6) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)