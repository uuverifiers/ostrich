;test regex (?:(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)\s[\d]{1,2}\s)?(?:1[012]|[1-9]):[0-5][0-9]\s(?:am|pm)
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "J") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.opt (re.++ (str.to_re "u") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (str.to_re "y")))))))) (re.++ (str.to_re "F") (re.++ (str.to_re "e") (re.++ (str.to_re "b") (re.opt (re.++ (str.to_re "r") (re.++ (str.to_re "u") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (str.to_re "y")))))))))) (re.++ (str.to_re "M") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.opt (re.++ (str.to_re "c") (str.to_re "h"))))))) (re.++ (str.to_re "A") (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.opt (re.++ (str.to_re "i") (str.to_re "l"))))))) (re.++ (str.to_re "M") (re.++ (str.to_re "a") (str.to_re "y")))) (re.++ (str.to_re "J") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.opt (str.to_re "e")))))) (re.++ (str.to_re "J") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (re.opt (str.to_re "y")))))) (re.++ (str.to_re "A") (re.++ (str.to_re "u") (re.++ (str.to_re "g") (re.opt (re.++ (str.to_re "u") (re.++ (str.to_re "s") (str.to_re "t")))))))) (re.++ (str.to_re "S") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.opt (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (str.to_re "r"))))))))))) (re.++ (str.to_re "O") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.opt (re.++ (str.to_re "o") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (str.to_re "r"))))))))) (re.++ (re.union (re.++ (str.to_re "N") (re.++ (str.to_re "o") (str.to_re "v"))) (re.++ (str.to_re "D") (re.++ (str.to_re "e") (str.to_re "c")))) (re.opt (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (str.to_re "r")))))))) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))) (re.++ (re.union (re.++ (str.to_re "1") (str.to_re "012")) (re.range "1" "9")) (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.++ (re.range "0" "9") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.union (re.++ (str.to_re "a") (str.to_re "m")) (re.++ (str.to_re "p") (str.to_re "m")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)