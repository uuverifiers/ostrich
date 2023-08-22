;test regex <xs:pattern value="([A,B,C,Z]{1}\w\?{2})"/>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "x") (re.++ (str.to_re "s") (re.++ (str.to_re ":") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.++ ((_ re.loop 1 1) (re.union (str.to_re "A") (re.union (str.to_re ",") (re.union (str.to_re "B") (re.union (str.to_re ",") (re.union (str.to_re "C") (re.union (str.to_re ",") (str.to_re "Z")))))))) (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) ((_ re.loop 2 2) (str.to_re "?")))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (str.to_re ">")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)