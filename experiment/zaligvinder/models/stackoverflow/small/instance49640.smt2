;test regex ^(dw|lat)_([^_]*)_(Paid-Search|Text-Ad)(?:_[^_]*){8}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "d") (str.to_re "w")) (re.++ (str.to_re "l") (re.++ (str.to_re "a") (str.to_re "t")))) (re.++ (str.to_re "_") (re.++ (re.* (re.diff re.allchar (str.to_re "_"))) (re.++ (str.to_re "_") (re.++ (re.union (re.++ (str.to_re "P") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "-") (re.++ (str.to_re "S") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "c") (str.to_re "h"))))))))))) (re.++ (str.to_re "T") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re "-") (re.++ (str.to_re "A") (str.to_re "d")))))))) ((_ re.loop 8 8) (re.++ (str.to_re "_") (re.* (re.diff re.allchar (str.to_re "_"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)