;test regex ^(?:(Website22RC15)|(Website1?\d{1,2}(?:RC)?1?\d{1,2}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (str.to_re "W") (re.++ (str.to_re "e") (re.++ (str.to_re "b") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "22") (re.++ (str.to_re "R") (re.++ (str.to_re "C") (str.to_re "15"))))))))))) (re.++ (str.to_re "W") (re.++ (str.to_re "e") (re.++ (str.to_re "b") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (re.opt (str.to_re "1")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re "R") (str.to_re "C"))) (re.++ (re.opt (str.to_re "1")) ((_ re.loop 1 2) (re.range "0" "9"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)