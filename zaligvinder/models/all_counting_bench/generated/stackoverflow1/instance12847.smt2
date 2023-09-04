;test regex 'A-Topeka-Firesale\:\s\*132\*\d{2,5}\*[23]\d{9}\#'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "A") (re.++ (str.to_re "-") (re.++ (str.to_re "T") (re.++ (str.to_re "o") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "k") (re.++ (str.to_re "a") (re.++ (str.to_re "-") (re.++ (str.to_re "F") (re.++ (str.to_re "i") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re ":") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (str.to_re "*") (re.++ (str.to_re "132") (re.++ (str.to_re "*") (re.++ ((_ re.loop 2 5) (re.range "0" "9")) (re.++ (str.to_re "*") (re.++ (str.to_re "23") (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.++ (str.to_re "#") (str.to_re "\u{27}")))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)