;test regex "taskDate"\: newDate\("[a-zA-z]* \d{2}, \d{4} \d{2}\:\d{2}\:\d{2}"\)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "k") (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re "w") (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "(") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "z"))) (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9"))))))))))))))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "\u{22}") (str.to_re ")"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)