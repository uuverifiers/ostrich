;test regex \[.*\]|Y{2,4}|M{1,4}|D{1,2}|d{1,4}|H{1,2}|h{1,2}|a|A|m{1,2}|s{1,2}|Z{1,2}|SSS
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "[") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "]"))) ((_ re.loop 2 4) (str.to_re "Y"))) ((_ re.loop 1 4) (str.to_re "M"))) ((_ re.loop 1 2) (str.to_re "D"))) ((_ re.loop 1 4) (str.to_re "d"))) ((_ re.loop 1 2) (str.to_re "H"))) ((_ re.loop 1 2) (str.to_re "h"))) (str.to_re "a")) (str.to_re "A")) ((_ re.loop 1 2) (str.to_re "m"))) ((_ re.loop 1 2) (str.to_re "s"))) ((_ re.loop 1 2) (str.to_re "Z"))) (re.++ (str.to_re "S") (re.++ (str.to_re "S") (str.to_re "S"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)