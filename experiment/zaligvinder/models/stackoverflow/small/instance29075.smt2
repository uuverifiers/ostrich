;test regex Pattern.compile("(\\d{3}|VRB)|(\\d{2,3})|(G\\d{2,3})|(KT|MPS|KMH)")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "P") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.union (re.union (re.union (re.++ (str.to_re "\u{22}") (re.union (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d"))) (re.++ (str.to_re "V") (re.++ (str.to_re "R") (str.to_re "B"))))) (re.++ (str.to_re "\\") ((_ re.loop 2 3) (str.to_re "d")))) (re.++ (str.to_re "G") (re.++ (str.to_re "\\") ((_ re.loop 2 3) (str.to_re "d"))))) (re.++ (re.union (re.union (re.++ (str.to_re "K") (str.to_re "T")) (re.++ (str.to_re "M") (re.++ (str.to_re "P") (str.to_re "S")))) (re.++ (str.to_re "K") (re.++ (str.to_re "M") (str.to_re "H")))) (str.to_re "\u{22}"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)