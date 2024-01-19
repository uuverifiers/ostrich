;test regex /^ {2}<pubDate>([^<]*)<\/pubdate>/m
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (str.to_re " ")) (re.++ (str.to_re "<") (re.++ (str.to_re "p") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re ">") (re.++ (re.* (re.diff re.allchar (str.to_re "<"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "p") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "d") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re ">") (re.++ (str.to_re "/") (str.to_re "m")))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)