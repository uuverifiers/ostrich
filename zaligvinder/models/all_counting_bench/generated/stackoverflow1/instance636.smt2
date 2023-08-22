;test regex ^[-]+[' ']*Original[' ']{0,1}Message[' ']*[-]+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (str.to_re "-")) (re.++ (re.* (re.union (str.to_re "\u{27}") (re.union (str.to_re " ") (str.to_re "\u{27}")))) (re.++ (str.to_re "O") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ ((_ re.loop 0 1) (re.union (str.to_re "\u{27}") (re.union (str.to_re " ") (str.to_re "\u{27}")))) (re.++ (str.to_re "M") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "s") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (re.* (re.union (str.to_re "\u{27}") (re.union (str.to_re " ") (str.to_re "\u{27}")))) (re.+ (str.to_re "-")))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)