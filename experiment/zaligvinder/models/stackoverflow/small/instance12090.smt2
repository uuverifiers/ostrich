;test regex [Ww][A-Za-z]{5,7}[aA][lL]([sS])?
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "W") (str.to_re "w")) (re.++ ((_ re.loop 5 7) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.++ (re.union (str.to_re "l") (str.to_re "L")) (re.opt (re.union (str.to_re "s") (str.to_re "S")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)