;test regex REGEXP '[^DOG][^NESTEL]{3}'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "P") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (re.inter (re.diff re.allchar (str.to_re "D")) (re.inter (re.diff re.allchar (str.to_re "O")) (re.diff re.allchar (str.to_re "G")))) (re.++ ((_ re.loop 3 3) (re.inter (re.diff re.allchar (str.to_re "N")) (re.inter (re.diff re.allchar (str.to_re "E")) (re.inter (re.diff re.allchar (str.to_re "S")) (re.inter (re.diff re.allchar (str.to_re "T")) (re.inter (re.diff re.allchar (str.to_re "E")) (re.diff re.allchar (str.to_re "L")))))))) (str.to_re "\u{27}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)