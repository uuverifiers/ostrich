;test regex ^jwclark.{0,25}[@][^d][^o][^m][^a][^i][^n].{0,25}\.com.{0,25}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "j") (re.++ (str.to_re "w") (re.++ (str.to_re "c") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "k") (re.++ ((_ re.loop 0 25) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "@") (re.++ (re.diff re.allchar (str.to_re "d")) (re.++ (re.diff re.allchar (str.to_re "o")) (re.++ (re.diff re.allchar (str.to_re "m")) (re.++ (re.diff re.allchar (str.to_re "a")) (re.++ (re.diff re.allchar (str.to_re "i")) (re.++ (re.diff re.allchar (str.to_re "n")) (re.++ ((_ re.loop 0 25) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") ((_ re.loop 0 25) (re.diff re.allchar (str.to_re "\n")))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)