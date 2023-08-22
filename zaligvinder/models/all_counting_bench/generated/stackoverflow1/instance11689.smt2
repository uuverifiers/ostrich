;test regex awk '/^(([0-9]{1,2}\/){2}[0-9]{2}\s([0-9]{1,2}:){2}[0-9]{2})/' file
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "a") (re.++ (str.to_re "w") (re.++ (str.to_re "k") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (str.to_re "/")))))) (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 2 2) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ ((_ re.loop 2 2) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ":"))) ((_ re.loop 2 2) (re.range "0" "9")))))) (re.++ (str.to_re "/") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (str.to_re "e"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)