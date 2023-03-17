;test regex (?:^[b-df-hj-np-tv-z][aeiou]-\d{6}$)|(?:^\d{1,8}[a-z]{2,4}$)|(?:^\d{5},\d{5}$)|(?:^\d{3}:[a-z]{2}>\d{7}$)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.range "b" "d") (re.union (re.range "f" "h") (re.union (re.range "j" "n") (re.union (re.range "p" "t") (re.range "v" "z"))))) (re.++ (re.union (str.to_re "a") (re.union (str.to_re "e") (re.union (str.to_re "i") (re.union (str.to_re "o") (str.to_re "u"))))) (re.++ (str.to_re "-") ((_ re.loop 6 6) (re.range "0" "9")))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 8) (re.range "0" "9")) ((_ re.loop 2 4) (re.range "a" "z")))) (str.to_re ""))) (re.++ (re.++ (re.++ (str.to_re "") ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ (str.to_re ",") ((_ re.loop 5 5) (re.range "0" "9")))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re ">") ((_ re.loop 7 7) (re.range "0" "9"))))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)