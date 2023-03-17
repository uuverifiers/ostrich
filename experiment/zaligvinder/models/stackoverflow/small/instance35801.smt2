;test regex ^(<em>.?)([ABCDEF] (.</em>?)){4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "<") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re ">") (re.opt (re.diff re.allchar (str.to_re "\n"))))))) ((_ re.loop 4 4) (re.++ (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (re.union (str.to_re "D") (re.union (str.to_re "E") (str.to_re "F")))))) (re.++ (str.to_re " ") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.opt (str.to_re ">")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)