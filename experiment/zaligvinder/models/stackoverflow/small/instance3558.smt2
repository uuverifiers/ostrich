;test regex ^[a-zA-Z!$.&0-9]{4,24}@[a-zA-Z]{2,}\.(edu|com|net)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 24) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "!") (re.union (str.to_re "$") (re.union (str.to_re ".") (re.union (str.to_re "&") (re.range "0" "9")))))))) (re.++ (str.to_re "@") (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "e") (re.++ (str.to_re "d") (str.to_re "u"))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m")))) (re.++ (str.to_re "n") (re.++ (str.to_re "e") (str.to_re "t"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)