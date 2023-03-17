;test regex if (str.matches("[A]{0,3}[P]{0,3}[L]{0,1}[E]{0,1}[S]{0,1}"))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "i") (re.++ (str.to_re "f") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 0 3) (str.to_re "A")) (re.++ ((_ re.loop 0 3) (str.to_re "P")) (re.++ ((_ re.loop 0 1) (str.to_re "L")) (re.++ ((_ re.loop 0 1) (str.to_re "E")) (re.++ ((_ re.loop 0 1) (str.to_re "S")) (str.to_re "\u{22}")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)