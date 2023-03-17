;test regex (^|\s+)(North|South|East|West){1,2}(ern)?(\s+|$)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "") (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.++ ((_ re.loop 1 2) (re.union (re.union (re.union (re.++ (str.to_re "N") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "t") (str.to_re "h"))))) (re.++ (str.to_re "S") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (str.to_re "h")))))) (re.++ (str.to_re "E") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (str.to_re "t"))))) (re.++ (str.to_re "W") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (str.to_re "t")))))) (re.++ (re.opt (re.++ (str.to_re "e") (re.++ (str.to_re "r") (str.to_re "n")))) (re.union (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (str.to_re "")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)