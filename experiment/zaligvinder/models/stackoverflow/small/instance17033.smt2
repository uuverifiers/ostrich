;test regex dijit.byId(nameID).regExp = "([0-9]{0,3}[.]?)*[0-9]{1,3},[0-9]*|[0-9]";
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "j") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "b") (re.++ (str.to_re "y") (re.++ (str.to_re "I") (re.++ (str.to_re "d") (re.++ (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "I") (str.to_re "D")))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.opt (str.to_re ".")))) ((_ re.loop 1 3) (re.range "0" "9"))))))))))))))))))))))))) (re.++ (str.to_re ",") (re.* (re.range "0" "9")))) (re.++ (re.range "0" "9") (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)