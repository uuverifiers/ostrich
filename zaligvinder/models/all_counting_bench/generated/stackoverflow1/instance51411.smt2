;test regex ^[A-Z]{3,}_([SIPFLH]).*;
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 3 3) (re.range "A" "Z"))) (re.++ (str.to_re "_") (re.++ (re.union (str.to_re "S") (re.union (str.to_re "I") (re.union (str.to_re "P") (re.union (str.to_re "F") (re.union (str.to_re "L") (str.to_re "H")))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re ";"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)