;test regex (?:[Yy][Oo][Uu][Tt][Uu][Bb][Ee]\.[Cc][Oo][Mm]/watch\?v=)([\w-]{11})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (str.to_re "Y") (str.to_re "y")) (re.++ (re.union (str.to_re "O") (str.to_re "o")) (re.++ (re.union (str.to_re "U") (str.to_re "u")) (re.++ (re.union (str.to_re "T") (str.to_re "t")) (re.++ (re.union (str.to_re "U") (str.to_re "u")) (re.++ (re.union (str.to_re "B") (str.to_re "b")) (re.++ (re.union (str.to_re "E") (str.to_re "e")) (re.++ (str.to_re ".") (re.++ (re.union (str.to_re "C") (str.to_re "c")) (re.++ (re.union (str.to_re "O") (str.to_re "o")) (re.++ (re.union (str.to_re "M") (str.to_re "m")) (re.++ (str.to_re "/") (re.++ (str.to_re "w") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "?") (re.++ (str.to_re "v") (str.to_re "=")))))))))))))))))))) ((_ re.loop 11 11) (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "-"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)