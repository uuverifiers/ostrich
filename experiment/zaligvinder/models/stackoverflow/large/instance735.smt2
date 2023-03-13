;test regex ^,?(?:[1-5]\d|[1-9])(?:,(?:[1-5]\d|[1-9])){4}(?:,[1-5]){21}(?:,(?:true|false)){27}(?:,[1-5]){5}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.opt (str.to_re ",")) (re.++ (re.union (re.++ (re.range "1" "5") (re.range "0" "9")) (re.range "1" "9")) (re.++ ((_ re.loop 4 4) (re.++ (str.to_re ",") (re.union (re.++ (re.range "1" "5") (re.range "0" "9")) (re.range "1" "9")))) (re.++ ((_ re.loop 21 21) (re.++ (str.to_re ",") (re.range "1" "5"))) (re.++ ((_ re.loop 27 27) (re.++ (str.to_re ",") (re.union (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "u") (str.to_re "e")))) (re.++ (str.to_re "f") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "s") (str.to_re "e")))))))) ((_ re.loop 5 5) (re.++ (str.to_re ",") (re.range "1" "5")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)