;test regex ^(\d{2}:\d{2}:\d{2}\h*\d{1,2}-\d{1,2}-\d{1,2}|\d{7})\h*([a-zA-Z]{3}day)?\h*(.+)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.* (str.to_re "h")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 1 2) (re.range "0" "9")))))))))))) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (re.* (str.to_re "h")) (re.++ (re.opt (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "d") (re.++ (str.to_re "a") (str.to_re "y"))))) (re.++ (re.* (str.to_re "h")) (re.+ (re.diff re.allchar (str.to_re "\n"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)