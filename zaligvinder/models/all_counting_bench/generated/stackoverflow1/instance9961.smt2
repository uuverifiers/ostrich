;test regex IMG_[0-9]{4}\.[JPG]{3}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "I") (re.++ (str.to_re "M") (re.++ (str.to_re "G") (re.++ (str.to_re "_") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.union (str.to_re "J") (re.union (str.to_re "P") (str.to_re "G")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)