;test regex ([:word:].*[:punct:].){10}team([:punct:].[:word:].*){10}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 10 10) (re.++ (re.union (str.to_re ":") (re.union (str.to_re "w") (re.union (str.to_re "o") (re.union (str.to_re "r") (re.union (str.to_re "d") (str.to_re ":")))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re ":") (re.union (str.to_re "p") (re.union (str.to_re "u") (re.union (str.to_re "n") (re.union (str.to_re "c") (re.union (str.to_re "t") (str.to_re ":"))))))) (re.diff re.allchar (str.to_re "\n")))))) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "m") ((_ re.loop 10 10) (re.++ (re.union (str.to_re ":") (re.union (str.to_re "p") (re.union (str.to_re "u") (re.union (str.to_re "n") (re.union (str.to_re "c") (re.union (str.to_re "t") (str.to_re ":"))))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.union (str.to_re ":") (re.union (str.to_re "w") (re.union (str.to_re "o") (re.union (str.to_re "r") (re.union (str.to_re "d") (str.to_re ":")))))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)