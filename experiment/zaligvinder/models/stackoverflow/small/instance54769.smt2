;test regex ^(?:[0-9]{1,4}|[bcdfghj-np-tv-z]*[aeiou][a-z]*|[a-z]+[0-9][a-z0-9]*|[0-9]+[a-z][a-z0-9]*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (re.* (re.union (str.to_re "b") (re.union (str.to_re "c") (re.union (str.to_re "d") (re.union (str.to_re "f") (re.union (str.to_re "g") (re.union (str.to_re "h") (re.union (re.range "j" "n") (re.union (re.range "p" "t") (re.range "v" "z")))))))))) (re.++ (re.union (str.to_re "a") (re.union (str.to_re "e") (re.union (str.to_re "i") (re.union (str.to_re "o") (str.to_re "u"))))) (re.* (re.range "a" "z"))))) (re.++ (re.+ (re.range "a" "z")) (re.++ (re.range "0" "9") (re.* (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ (re.+ (re.range "0" "9")) (re.++ (re.range "a" "z") (re.* (re.union (re.range "a" "z") (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)