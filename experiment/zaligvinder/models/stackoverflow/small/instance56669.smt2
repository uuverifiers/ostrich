;test regex ^[^aeiouAEIOU01]{7}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 7 7) (re.inter (re.diff re.allchar (str.to_re "a")) (re.inter (re.diff re.allchar (str.to_re "e")) (re.inter (re.diff re.allchar (str.to_re "i")) (re.inter (re.diff re.allchar (str.to_re "o")) (re.inter (re.diff re.allchar (str.to_re "u")) (re.inter (re.diff re.allchar (str.to_re "A")) (re.inter (re.diff re.allchar (str.to_re "E")) (re.inter (re.diff re.allchar (str.to_re "I")) (re.inter (re.diff re.allchar (str.to_re "O")) (re.inter (re.diff re.allchar (str.to_re "U")) (re.diff re.allchar (str.to_re "01")))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)