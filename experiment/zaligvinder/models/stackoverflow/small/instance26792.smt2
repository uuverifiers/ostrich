;test regex grep -P '^[^.]+(?:\.[^.]+){2,}$' test.csv
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "P") (re.++ (str.to_re " ") (str.to_re "\u{27}"))))))))) (re.++ (str.to_re "") (re.++ (re.+ (re.diff re.allchar (str.to_re "."))) (re.++ (re.* (re.++ (str.to_re ".") (re.+ (re.diff re.allchar (str.to_re "."))))) ((_ re.loop 2 2) (re.++ (str.to_re ".") (re.+ (re.diff re.allchar (str.to_re "."))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "s") (str.to_re "v"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)