;test regex (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ([0-3]\d) ([12][09]\d{2}) ([01]\d):([0-5]\d):([0-5]\d):(\d{3})(AM|PM)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "J") (re.++ (str.to_re "a") (str.to_re "n"))) (re.++ (str.to_re "F") (re.++ (str.to_re "e") (str.to_re "b")))) (re.++ (str.to_re "M") (re.++ (str.to_re "a") (str.to_re "r")))) (re.++ (str.to_re "A") (re.++ (str.to_re "p") (str.to_re "r")))) (re.++ (str.to_re "M") (re.++ (str.to_re "a") (str.to_re "y")))) (re.++ (str.to_re "J") (re.++ (str.to_re "u") (str.to_re "n")))) (re.++ (str.to_re "J") (re.++ (str.to_re "u") (str.to_re "l")))) (re.++ (str.to_re "A") (re.++ (str.to_re "u") (str.to_re "g")))) (re.++ (str.to_re "S") (re.++ (str.to_re "e") (str.to_re "p")))) (re.++ (str.to_re "O") (re.++ (str.to_re "c") (str.to_re "t")))) (re.++ (str.to_re "N") (re.++ (str.to_re "o") (str.to_re "v")))) (re.++ (str.to_re "D") (re.++ (str.to_re "e") (str.to_re "c")))) (re.++ (str.to_re " ") (re.++ (re.++ (re.range "0" "3") (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re "12") (re.++ (str.to_re "09") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re "01") (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ (re.++ (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ (re.++ (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (re.++ (str.to_re "A") (str.to_re "M")) (re.++ (str.to_re "P") (str.to_re "M"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)