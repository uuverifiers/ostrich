;test regex @"\\b([0-9]{3}|VRB)([0-9]{2,3})G?([0-9]{2,3})?(KT|MPS|KMH)\\b"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "@") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (re.union ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "V") (re.++ (str.to_re "R") (str.to_re "B")))) (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (re.opt (str.to_re "G")) (re.++ (re.opt ((_ re.loop 2 3) (re.range "0" "9"))) (re.++ (re.union (re.union (re.++ (str.to_re "K") (str.to_re "T")) (re.++ (str.to_re "M") (re.++ (str.to_re "P") (str.to_re "S")))) (re.++ (str.to_re "K") (re.++ (str.to_re "M") (str.to_re "H")))) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (str.to_re "\u{22}"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)