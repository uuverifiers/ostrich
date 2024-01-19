;test regex ^([1-2]0[0-9] )?[A-D] [0-9] [0-9]{3} [A-L] [0-9]{3}[A-P][0-9]{2}( 0[0-9])?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.range "1" "2") (re.++ (str.to_re "0") (re.++ (re.range "0" "9") (str.to_re " "))))) (re.++ (re.range "A" "D") (re.++ (str.to_re " ") (re.++ (re.range "0" "9") (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.range "A" "L") (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.range "A" "P") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re " ") (re.++ (str.to_re "0") (re.range "0" "9"))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)