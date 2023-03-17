;test regex /^[1-9]\d{0,2}(,\d{1,3})*(\.\d+)?$/.test( "2.45" ); //true
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (re.range "1" "9") (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (re.* (re.++ (str.to_re ",") ((_ re.loop 1 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "2") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "45") (re.++ (str.to_re "\u{22}") (str.to_re " "))))))) (re.++ (str.to_re ";") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "u") (str.to_re "e")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)