;test regex ^\n*[uU][sS][eE][rR][nN][aA][mM][eE]\:[^\n]{100}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (str.to_re "\u{0a}")) (re.++ (re.union (str.to_re "u") (str.to_re "U")) (re.++ (re.union (str.to_re "s") (str.to_re "S")) (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.++ (re.union (str.to_re "r") (str.to_re "R")) (re.++ (re.union (str.to_re "n") (str.to_re "N")) (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.++ (re.union (str.to_re "m") (str.to_re "M")) (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.++ (str.to_re ":") ((_ re.loop 100 100) (re.diff re.allchar (str.to_re "\u{0a}"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)