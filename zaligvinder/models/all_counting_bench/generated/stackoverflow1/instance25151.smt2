;test regex [a-zA-Z]+(Field|Type)[0-9]{1,2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.union (re.++ (str.to_re "F") (re.++ (str.to_re "i") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (str.to_re "d"))))) (re.++ (str.to_re "T") (re.++ (str.to_re "y") (re.++ (str.to_re "p") (str.to_re "e"))))) ((_ re.loop 1 2) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)