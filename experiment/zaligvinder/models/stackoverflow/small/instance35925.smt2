;test regex std::regex re(R"(\d{3}\(a\.o\.e\)\.u\.i\.y\w+)");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "d") (re.++ (str.to_re ":") (re.++ (str.to_re ":") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (re.++ (str.to_re "R") (re.++ (str.to_re "\u{22}") (re.++ (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "(") (re.++ (str.to_re "a") (re.++ (str.to_re ".") (re.++ (str.to_re "o") (re.++ (str.to_re ".") (re.++ (str.to_re "e") (re.++ (str.to_re ")") (re.++ (str.to_re ".") (re.++ (str.to_re "u") (re.++ (str.to_re ".") (re.++ (str.to_re "i") (re.++ (str.to_re ".") (re.++ (str.to_re "y") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))))))))))))) (str.to_re "\u{22}")))) (str.to_re ";")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)