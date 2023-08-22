;test regex /On.*? \d{1,2}\/\d{1,2}\/\d{1,4}(, at)? \d{1,2}:\d{1,2} (?:AM|PM),.*?wrote:/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "O") (re.++ (str.to_re "n") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (str.to_re "t"))))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re " ") (re.union (re.++ (str.to_re "A") (str.to_re "M")) (re.++ (str.to_re "P") (str.to_re "M"))))))))))))))))))) (re.++ (str.to_re ",") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "w") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re ":") (str.to_re "/"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)