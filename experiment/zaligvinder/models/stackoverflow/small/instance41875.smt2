;test regex ^RegZStmntAdj\d_[\d]{8}\.txt$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "Z") (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "m") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "A") (re.++ (str.to_re "d") (re.++ (str.to_re "j") (re.++ (re.range "0" "9") (re.++ (str.to_re "_") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t")))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)