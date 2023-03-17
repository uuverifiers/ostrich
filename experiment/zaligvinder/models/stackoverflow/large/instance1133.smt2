;test regex <xsd:pattern value="[a-zA-Z (\-)?]{0,100}"/>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "x") (re.++ (str.to_re "s") (re.++ (str.to_re "d") (re.++ (str.to_re ":") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 0 100) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re " ") (re.union (str.to_re "(") (re.union (str.to_re "-") (re.union (str.to_re ")") (str.to_re "?")))))))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (str.to_re ">"))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)