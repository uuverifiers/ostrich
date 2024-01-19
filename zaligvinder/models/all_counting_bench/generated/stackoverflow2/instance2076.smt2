;test regex ^[a-zA-Z?-0-9\s]{3,50}[.]{1}(([pP][dD][fF]))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 50) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "?") (re.union (str.to_re "-") (re.union (re.range "0" "9") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))) (re.++ ((_ re.loop 1 1) (str.to_re ".")) (re.++ (re.union (str.to_re "p") (str.to_re "P")) (re.++ (re.union (str.to_re "d") (str.to_re "D")) (re.union (str.to_re "f") (str.to_re "F"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)