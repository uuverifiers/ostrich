;test regex [0-9]{1,2}(st|nd|rd|th) of \w{3,9} \d{4}<\/span> \d{1,2}:\d{1,2}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "s") (str.to_re "t")) (re.++ (str.to_re "n") (str.to_re "d"))) (re.++ (str.to_re "r") (str.to_re "d"))) (re.++ (str.to_re "t") (str.to_re "h"))) (re.++ (str.to_re " ") (re.++ (str.to_re "o") (re.++ (str.to_re "f") (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 9) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re ">") (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ":") ((_ re.loop 1 2) (re.range "0" "9")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)