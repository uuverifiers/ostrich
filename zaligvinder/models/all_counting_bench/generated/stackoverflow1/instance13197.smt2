;test regex pattern.compile("^\\[\\]0-9*#X[^-]{1,50}$");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (str.to_re "\\") (re.++ (str.to_re "\\") (re.++ (str.to_re "0") (re.++ (str.to_re "-") (re.++ (re.* (str.to_re "9")) (re.++ (str.to_re "#") (re.++ (str.to_re "X") ((_ re.loop 1 50) (re.diff re.allchar (str.to_re "-")))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))) (str.to_re ";")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)