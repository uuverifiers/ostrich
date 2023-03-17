;test regex background-color: ?(\#[a-fA-F0-9]{3,6}|rgb\([0-9]{2,3},[0-9]{2,3},[0-9]{2,3}\))\;
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "-") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re ":") (re.++ (re.opt (str.to_re " ")) (re.++ (re.union (re.++ (str.to_re "#") ((_ re.loop 3 6) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9"))))) (re.++ (re.++ (re.++ (str.to_re "r") (re.++ (str.to_re "g") (re.++ (str.to_re "b") (re.++ (str.to_re "(") ((_ re.loop 2 3) (re.range "0" "9")))))) (re.++ (str.to_re ",") ((_ re.loop 2 3) (re.range "0" "9")))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ")"))))) (str.to_re ";"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)