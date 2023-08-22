;test regex ^[1-9][0-9]{3}[ ]?(([a-rt-zA-RT-Z]{2})|([sS][^dasDAS]))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.range "1" "9") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (str.to_re " ")) (re.union ((_ re.loop 2 2) (re.union (re.range "a" "r") (re.union (re.range "t" "z") (re.union (re.range "A" "R") (re.range "T" "Z"))))) (re.++ (re.union (str.to_re "s") (str.to_re "S")) (re.inter (re.diff re.allchar (str.to_re "d")) (re.inter (re.diff re.allchar (str.to_re "a")) (re.inter (re.diff re.allchar (str.to_re "s")) (re.inter (re.diff re.allchar (str.to_re "D")) (re.inter (re.diff re.allchar (str.to_re "A")) (re.diff re.allchar (str.to_re "S"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)