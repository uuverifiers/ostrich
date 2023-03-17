;test regex (H | h)(E | e)(L | l){2}(O | o)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "H") (str.to_re " ")) (re.++ (str.to_re " ") (str.to_re "h"))) (re.++ (re.union (re.++ (str.to_re "E") (str.to_re " ")) (re.++ (str.to_re " ") (str.to_re "e"))) (re.++ ((_ re.loop 2 2) (re.union (re.++ (str.to_re "L") (str.to_re " ")) (re.++ (str.to_re " ") (str.to_re "l")))) (re.union (re.++ (str.to_re "O") (str.to_re " ")) (re.++ (str.to_re " ") (str.to_re "o"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)