;test regex lotto tickets\D{0,15}(\d+\,\d+|\d+\.\d+|\d+)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "s") (re.++ ((_ re.loop 0 15) (re.diff re.allchar (re.range "0" "9"))) (re.union (re.union (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ",") (re.+ (re.range "0" "9")))) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (re.+ (re.range "0" "9")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)