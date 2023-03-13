;test regex (?:V|v|pri|Pri|Od|od|Do|do|Z|z|na|Na|Nad|nad)((?:\s+[A-Za-z]+){1,3})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "V") (str.to_re "v")) (re.++ (str.to_re "p") (re.++ (str.to_re "r") (str.to_re "i")))) (re.++ (str.to_re "P") (re.++ (str.to_re "r") (str.to_re "i")))) (re.++ (str.to_re "O") (str.to_re "d"))) (re.++ (str.to_re "o") (str.to_re "d"))) (re.++ (str.to_re "D") (str.to_re "o"))) (re.++ (str.to_re "d") (str.to_re "o"))) (str.to_re "Z")) (str.to_re "z")) (re.++ (str.to_re "n") (str.to_re "a"))) (re.++ (str.to_re "N") (str.to_re "a"))) (re.++ (str.to_re "N") (re.++ (str.to_re "a") (str.to_re "d")))) (re.++ (str.to_re "n") (re.++ (str.to_re "a") (str.to_re "d")))) ((_ re.loop 1 3) (re.++ (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)