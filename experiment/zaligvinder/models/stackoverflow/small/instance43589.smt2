;test regex ([a-z0-9][-a-z0-9_\+\.]*[a-z0-9])@([a-z0-9][-a-z0-9\.]*[a-z0-9]\.(aero|AERO|biz|BIZ|com|COM|coop|COOP|edu|EDU|gov|GOV|info|INFO|int|INT|mil|MIL|museum|MUSUEM|name|NAME|net|NET|org|ORG|pro|PRO)|([0-9]{1,3}\.{3}[0-9]{1,3}))
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ (re.* (re.union (str.to_re "-") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (re.union (str.to_re "+") (str.to_re "."))))))) (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (str.to_re "@") (re.union (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ (re.* (re.union (str.to_re "-") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "."))))) (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ (str.to_re ".") (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "a") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (str.to_re "o")))) (re.++ (str.to_re "A") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (str.to_re "O"))))) (re.++ (str.to_re "b") (re.++ (str.to_re "i") (str.to_re "z")))) (re.++ (str.to_re "B") (re.++ (str.to_re "I") (str.to_re "Z")))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m")))) (re.++ (str.to_re "C") (re.++ (str.to_re "O") (str.to_re "M")))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (str.to_re "p"))))) (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "O") (str.to_re "P"))))) (re.++ (str.to_re "e") (re.++ (str.to_re "d") (str.to_re "u")))) (re.++ (str.to_re "E") (re.++ (str.to_re "D") (str.to_re "U")))) (re.++ (str.to_re "g") (re.++ (str.to_re "o") (str.to_re "v")))) (re.++ (str.to_re "G") (re.++ (str.to_re "O") (str.to_re "V")))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "f") (str.to_re "o"))))) (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "F") (str.to_re "O"))))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "t")))) (re.++ (str.to_re "I") (re.++ (str.to_re "N") (str.to_re "T")))) (re.++ (str.to_re "m") (re.++ (str.to_re "i") (str.to_re "l")))) (re.++ (str.to_re "M") (re.++ (str.to_re "I") (str.to_re "L")))) (re.++ (str.to_re "m") (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "u") (str.to_re "m"))))))) (re.++ (str.to_re "M") (re.++ (str.to_re "U") (re.++ (str.to_re "S") (re.++ (str.to_re "U") (re.++ (str.to_re "E") (str.to_re "M"))))))) (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (str.to_re "e"))))) (re.++ (str.to_re "N") (re.++ (str.to_re "A") (re.++ (str.to_re "M") (str.to_re "E"))))) (re.++ (str.to_re "n") (re.++ (str.to_re "e") (str.to_re "t")))) (re.++ (str.to_re "N") (re.++ (str.to_re "E") (str.to_re "T")))) (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re "g")))) (re.++ (str.to_re "O") (re.++ (str.to_re "R") (str.to_re "G")))) (re.++ (str.to_re "p") (re.++ (str.to_re "r") (str.to_re "o")))) (re.++ (str.to_re "P") (re.++ (str.to_re "R") (str.to_re "O")))))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (str.to_re ".")) ((_ re.loop 1 3) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)