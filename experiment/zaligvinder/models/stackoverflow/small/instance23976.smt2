;test regex ((?:\d{1,3}\.){3}\d{1,3}(?:-\d+)?)(?:.*?((?:IR |INC)\d+))?
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "."))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") (re.+ (re.range "0" "9")))))) (re.opt (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.++ (str.to_re "I") (re.++ (str.to_re "R") (str.to_re " "))) (re.++ (str.to_re "I") (re.++ (str.to_re "N") (str.to_re "C")))) (re.+ (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)