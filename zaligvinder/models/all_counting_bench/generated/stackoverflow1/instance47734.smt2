;test regex (?:jan|feb|mar) +\d{2} +\d{4} +\d{2}:\d{2}:\d{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "a") (str.to_re "n"))) (re.++ (str.to_re "f") (re.++ (str.to_re "e") (str.to_re "b")))) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (str.to_re "r")))) (re.++ (re.+ (str.to_re " ")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.+ (str.to_re " ")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (re.+ (str.to_re " ")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") ((_ re.loop 2 2) (re.range "0" "9"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)