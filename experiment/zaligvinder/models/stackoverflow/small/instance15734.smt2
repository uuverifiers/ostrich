;test regex Statement_([0-9]{6})([0-9]{8})\.(csv|qif|qfx|ofx)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "_") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re ".") (re.union (re.union (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "s") (str.to_re "v"))) (re.++ (str.to_re "q") (re.++ (str.to_re "i") (str.to_re "f")))) (re.++ (str.to_re "q") (re.++ (str.to_re "f") (str.to_re "x")))) (re.++ (str.to_re "o") (re.++ (str.to_re "f") (str.to_re "x"))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)