;test regex ^\/color\s+(set|update)?\s*(#[AFaf09]{6}|[A-Fa-f0-9]{3}|[a-zA-Z]{1,20})\s*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.opt (re.union (re.++ (str.to_re "s") (re.++ (str.to_re "e") (str.to_re "t"))) (re.++ (str.to_re "u") (re.++ (str.to_re "p") (re.++ (str.to_re "d") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (str.to_re "e")))))))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.union (re.union (re.++ (str.to_re "#") ((_ re.loop 6 6) (re.union (str.to_re "A") (re.union (str.to_re "F") (re.union (str.to_re "a") (re.union (str.to_re "f") (str.to_re "09"))))))) ((_ re.loop 3 3) (re.union (re.range "A" "F") (re.union (re.range "a" "f") (re.range "0" "9"))))) ((_ re.loop 1 20) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)