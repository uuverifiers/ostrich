;test regex (?:([a-z]{3,9})\s*(\d{1,2})[stndrh]{2},\s*2012)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 3 9) (re.range "a" "z")) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (str.to_re "s") (re.union (str.to_re "t") (re.union (str.to_re "n") (re.union (str.to_re "d") (re.union (str.to_re "r") (str.to_re "h")))))))))) (re.++ (str.to_re ",") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (str.to_re "2012"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)