;test regex [^\pL\pN]{4}\pL[\pL\pN]{1,32}\pN[^\pL\pN]
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.inter (re.diff re.allchar (str.to_re "p")) (re.inter (re.diff re.allchar (str.to_re "L")) (re.inter (re.diff re.allchar (str.to_re "p")) (re.diff re.allchar (str.to_re "N")))))) (re.++ (str.to_re "p") (re.++ (str.to_re "L") (re.++ ((_ re.loop 1 32) (re.union (str.to_re "p") (re.union (str.to_re "L") (re.union (str.to_re "p") (str.to_re "N"))))) (re.++ (str.to_re "p") (re.++ (str.to_re "N") (re.inter (re.diff re.allchar (str.to_re "p")) (re.inter (re.diff re.allchar (str.to_re "L")) (re.inter (re.diff re.allchar (str.to_re "p")) (re.diff re.allchar (str.to_re "N")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)