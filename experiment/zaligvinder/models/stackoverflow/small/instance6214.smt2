;test regex /\/([0-9]{10,30})|(\+[^\/]{2,30})\//.exec(window.location.pathname);
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "/") (re.++ (str.to_re "/") ((_ re.loop 10 30) (re.range "0" "9")))) (re.++ (re.++ (str.to_re "+") ((_ re.loop 2 30) (re.diff re.allchar (str.to_re "/")))) (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (re.++ (str.to_re "w") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "w") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (str.to_re "e")))))))))))))))))))))))) (str.to_re ";")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)