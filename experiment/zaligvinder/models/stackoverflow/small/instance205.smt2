;test regex ^[a-zA-Z0-9]+\.[a-zA-Z0-9]+(@gmail|@hotmail)\.[a-zA-Z]{2,4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (re.union (re.++ (str.to_re "@") (re.++ (str.to_re "g") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (str.to_re "l")))))) (re.++ (str.to_re "@") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (str.to_re "l"))))))))) (re.++ (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)