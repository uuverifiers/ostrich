;test regex .* [cC][hH][oO][wW][nN] [^\u{20}]{100}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ (re.union (str.to_re "c") (str.to_re "C")) (re.++ (re.union (str.to_re "h") (str.to_re "H")) (re.++ (re.union (str.to_re "o") (str.to_re "O")) (re.++ (re.union (str.to_re "w") (str.to_re "W")) (re.++ (re.union (str.to_re "n") (str.to_re "N")) (re.++ (str.to_re " ") ((_ re.loop 100 100) (re.diff re.allchar (str.to_re "\u{20}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)