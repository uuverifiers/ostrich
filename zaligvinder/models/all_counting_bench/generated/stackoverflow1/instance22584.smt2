;test regex egrep '[ATGCN]{8}\+[ATGCN]{16}$' testSed.fastq
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 8 8) (re.union (str.to_re "A") (re.union (str.to_re "T") (re.union (str.to_re "G") (re.union (str.to_re "C") (str.to_re "N")))))) (re.++ (str.to_re "+") ((_ re.loop 16 16) (re.union (str.to_re "A") (re.union (str.to_re "T") (re.union (str.to_re "G") (re.union (str.to_re "C") (str.to_re "N"))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "S") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "f") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (str.to_re "q")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)