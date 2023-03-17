;test regex ([0-9A-Z]+)-(VE|GE)-(\\d{4,})-(S|A)-(\\d){2}(/\\d+)?\\.pdf
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re "-") (re.++ (re.union (re.++ (str.to_re "V") (str.to_re "E")) (re.++ (str.to_re "G") (str.to_re "E"))) (re.++ (str.to_re "-") (re.++ (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "d")) ((_ re.loop 4 4) (str.to_re "d")))) (re.++ (str.to_re "-") (re.++ (re.union (str.to_re "S") (str.to_re "A")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "\\") (str.to_re "d"))) (re.++ (re.opt (re.++ (str.to_re "/") (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)