;test regex var myregexp = /^(?:\D*\d){3,30}\D*$/g;<br/><br/>
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "/")))))))))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 3 30) (re.++ (re.* (re.diff re.allchar (re.range "0" "9"))) (re.range "0" "9"))) (re.* (re.diff re.allchar (re.range "0" "9")))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re "g") (re.++ (str.to_re ";") (re.++ (str.to_re "<") (re.++ (str.to_re "b") (re.++ (str.to_re "r") (re.++ (str.to_re "/") (re.++ (str.to_re ">") (re.++ (str.to_re "<") (re.++ (str.to_re "b") (re.++ (str.to_re "r") (re.++ (str.to_re "/") (str.to_re ">")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)