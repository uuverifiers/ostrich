;test regex (?:(?:(?:a|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve)?(?:(thir|four|fif|six|seven|eight|nine)teen)?)(?:(?:twen|thir|four|fif|six|seven|eight|nine)ty)?(?:(?:one|two|three|four|five|six|seven|eight|nine|ten) (?:(?:hundred|thousand|)|(?:\w.llion)))?(?: \w+)? dollar(?:s)?(?: and [0-9]{1,2} cents)?)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.opt (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "a") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (str.to_re "e")))) (re.++ (str.to_re "t") (re.++ (str.to_re "w") (str.to_re "o")))) (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (str.to_re "e")))))) (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (str.to_re "r"))))) (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (str.to_re "e"))))) (re.++ (str.to_re "s") (re.++ (str.to_re "i") (str.to_re "x")))) (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (str.to_re "n")))))) (re.++ (str.to_re "e") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "h") (str.to_re "t")))))) (re.++ (str.to_re "n") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "e"))))) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (str.to_re "n")))) (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (str.to_re "n"))))))) (re.++ (str.to_re "t") (re.++ (str.to_re "w") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "v") (str.to_re "e")))))))) (re.opt (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (str.to_re "r")))) (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (str.to_re "r"))))) (re.++ (str.to_re "f") (re.++ (str.to_re "i") (str.to_re "f")))) (re.++ (str.to_re "s") (re.++ (str.to_re "i") (str.to_re "x")))) (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (str.to_re "n")))))) (re.++ (str.to_re "e") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "h") (str.to_re "t")))))) (re.++ (str.to_re "n") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "e"))))) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "e") (str.to_re "n"))))))) (re.++ (re.opt (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "t") (re.++ (str.to_re "w") (re.++ (str.to_re "e") (str.to_re "n")))) (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (str.to_re "r"))))) (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (str.to_re "r"))))) (re.++ (str.to_re "f") (re.++ (str.to_re "i") (str.to_re "f")))) (re.++ (str.to_re "s") (re.++ (str.to_re "i") (str.to_re "x")))) (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (str.to_re "n")))))) (re.++ (str.to_re "e") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "h") (str.to_re "t")))))) (re.++ (str.to_re "n") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "e"))))) (re.++ (str.to_re "t") (str.to_re "y")))) (re.++ (re.opt (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "o") (re.++ (str.to_re "n") (str.to_re "e"))) (re.++ (str.to_re "t") (re.++ (str.to_re "w") (str.to_re "o")))) (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (str.to_re "e")))))) (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (str.to_re "r"))))) (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (str.to_re "e"))))) (re.++ (str.to_re "s") (re.++ (str.to_re "i") (str.to_re "x")))) (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (str.to_re "n")))))) (re.++ (str.to_re "e") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "h") (str.to_re "t")))))) (re.++ (str.to_re "n") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "e"))))) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (str.to_re "n")))) (re.++ (str.to_re " ") (re.union (re.union (re.++ (str.to_re "") (re.union (re.++ (str.to_re "h") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (str.to_re "d"))))))) (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (str.to_re "d")))))))))) (str.to_re "")) (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (str.to_re "n"))))))))))) (re.++ (re.opt (re.++ (str.to_re " ") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (re.opt (str.to_re "s")) (re.opt (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (str.to_re "s")))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)