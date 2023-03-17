;test regex grep -Po '^([^" ]+ |"[^"]*" ){12}\K([^" ]+|"[^"]*")' file
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "P") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 12 12) (re.union (re.++ (re.+ (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.diff re.allchar (str.to_re " ")))) (str.to_re " ")) (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "\u{22}"))) (re.++ (str.to_re "\u{22}") (str.to_re " ")))))) (re.++ (str.to_re "K") (re.++ (re.union (re.+ (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.diff re.allchar (str.to_re " ")))) (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "\u{22}"))) (str.to_re "\u{22}")))) (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (str.to_re "e")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)