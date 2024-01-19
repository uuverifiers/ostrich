;test regex //vod//final\_\d{0,99}.\d{0,99}\\-Frag\d{0,99}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "v") (re.++ (str.to_re "o") (re.++ (str.to_re "d") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "_") (re.++ ((_ re.loop 0 99) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 0 99) (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (str.to_re "-") (re.++ (str.to_re "F") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "g") ((_ re.loop 0 99) (re.range "0" "9"))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)