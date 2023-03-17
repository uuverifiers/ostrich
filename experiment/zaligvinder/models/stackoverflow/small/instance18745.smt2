;test regex /xyz(/[^i][^m][^p].*)?|/xyz/.{0,2}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "/") (re.++ (str.to_re "x") (re.++ (str.to_re "y") (re.++ (str.to_re "z") (re.opt (re.++ (str.to_re "/") (re.++ (re.diff re.allchar (str.to_re "i")) (re.++ (re.diff re.allchar (str.to_re "m")) (re.++ (re.diff re.allchar (str.to_re "p")) (re.* (re.diff re.allchar (str.to_re "\n")))))))))))) (re.++ (str.to_re "/") (re.++ (str.to_re "x") (re.++ (str.to_re "y") (re.++ (str.to_re "z") (re.++ (str.to_re "/") ((_ re.loop 0 2) (re.diff re.allchar (str.to_re "\n")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)