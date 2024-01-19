;test regex AND col NOT REGEXP '([^$&%@]*[$&%@]){4}'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "N") (re.++ (str.to_re "D") (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re " ") (re.++ (str.to_re "N") (re.++ (str.to_re "O") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "P") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 4 4) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "$")) (re.inter (re.diff re.allchar (str.to_re "&")) (re.inter (re.diff re.allchar (str.to_re "%")) (re.diff re.allchar (str.to_re "@")))))) (re.union (str.to_re "$") (re.union (str.to_re "&") (re.union (str.to_re "%") (str.to_re "@")))))) (str.to_re "\u{27}"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)