;test regex mycmd | pcregrep -M '^/ >  -{7}\n.*\n/ > $' | pcregrep -v '^/ >'
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re "c") (re.++ (str.to_re "m") (re.++ (str.to_re "d") (str.to_re " ")))))) (re.++ (re.++ (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "c") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "M") (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re ">") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ ((_ re.loop 7 7) (str.to_re "-")) (re.++ (str.to_re "\u{0a}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re ">") (str.to_re " "))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{27}") (str.to_re " "))))) (re.++ (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "c") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "v") (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re ">") (str.to_re "\u{27}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)