;test regex ^(?:[^i]|i[^n]|in[^s]|ins[^t]|inst[^a]|insta[^g]|instag[^r]|instagr[^a]|instagra[^m]|instagram[^.]).{1,30}\.fbcdn\.net$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.diff re.allchar (str.to_re "i")) (re.++ (str.to_re "i") (re.diff re.allchar (str.to_re "n")))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.diff re.allchar (str.to_re "s"))))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.diff re.allchar (str.to_re "t")))))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.diff re.allchar (str.to_re "a"))))))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.diff re.allchar (str.to_re "g")))))))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.diff re.allchar (str.to_re "r"))))))))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.diff re.allchar (str.to_re "a")))))))))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.diff re.allchar (str.to_re "m"))))))))))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.diff re.allchar (str.to_re ".")))))))))))) (re.++ ((_ re.loop 1 30) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.++ (str.to_re "f") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re "d") (re.++ (str.to_re "n") (re.++ (str.to_re ".") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (str.to_re "t"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)