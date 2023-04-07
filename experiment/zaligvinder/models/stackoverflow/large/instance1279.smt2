;test regex grep -oE 'Google[ ]{1,3}"[a-zA-Z0-9 ]{1,100}[., ]{0,3}"' filename
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "o") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "G") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (str.to_re "g") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ ((_ re.loop 1 3) (str.to_re " ")) (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 1 100) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re " "))))) (re.++ ((_ re.loop 0 3) (re.union (str.to_re ".") (re.union (str.to_re ",") (str.to_re " ")))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (str.to_re "e")))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)