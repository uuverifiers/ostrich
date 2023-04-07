;test regex u'^.*(?:Grundfl|gfl|wfl|wohnfl|whg|wohnung).*(\s\d{1,3}[.,]?\d{1,2}?)\s*(?:m\u00B2|qm)'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "u") (str.to_re "\u{27}")) (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "G") (re.++ (str.to_re "r") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "f") (str.to_re "l"))))))) (re.++ (str.to_re "g") (re.++ (str.to_re "f") (str.to_re "l")))) (re.++ (str.to_re "w") (re.++ (str.to_re "f") (str.to_re "l")))) (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "h") (re.++ (str.to_re "n") (re.++ (str.to_re "f") (str.to_re "l"))))))) (re.++ (str.to_re "w") (re.++ (str.to_re "h") (str.to_re "g")))) (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "h") (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (str.to_re "g")))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re ".") (str.to_re ","))) ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.union (re.++ (str.to_re "m") (str.to_re "\u{00b2}")) (re.++ (str.to_re "q") (str.to_re "m"))) (str.to_re "\u{27}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)