;test regex @media.*(min|max)-width:([ ]+)?(([0-9]{1,5})(\.[0-9]{1,20}|)(px|em))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "@") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "a") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.++ (str.to_re "m") (re.++ (str.to_re "i") (str.to_re "n"))) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (str.to_re "x")))) (re.++ (str.to_re "-") (re.++ (str.to_re "w") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re ":") (re.++ (re.opt (re.+ (str.to_re " "))) (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (re.++ (re.union (re.++ (str.to_re "") (re.++ (str.to_re ".") ((_ re.loop 1 20) (re.range "0" "9")))) (str.to_re "")) (re.union (re.++ (str.to_re "p") (str.to_re "x")) (re.++ (str.to_re "e") (str.to_re "m")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)