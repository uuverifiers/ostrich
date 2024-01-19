;test regex ([0-9a-fA-F]{40}) ([0-9a-fA-F]{40}) refs\/(heads|tags)\/(.*)( |00|\u0000)|^(0000)$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.union (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (str.to_re "s"))))) (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (str.to_re "s"))))) (re.++ (str.to_re "/") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (re.union (str.to_re " ") (str.to_re "00")) (str.to_re "\u{0000}")))))))))))))) (re.++ (re.++ (str.to_re "") (str.to_re "0000")) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)