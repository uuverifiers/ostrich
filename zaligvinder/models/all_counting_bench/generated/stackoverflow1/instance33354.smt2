;test regex "(((https)[:]{1}[//]{2}[a-z0-9]*.xyz[/]{1}([A-Za-z]*[/]{1}[A-Za-z]*.json(/n)?))?)+";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.+ (re.opt (re.++ (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (str.to_re "s"))))) (re.++ ((_ re.loop 1 1) (str.to_re ":")) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "/") (str.to_re "/"))) (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "x") (re.++ (str.to_re "y") (re.++ (str.to_re "z") (re.++ ((_ re.loop 1 1) (str.to_re "/")) (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ ((_ re.loop 1 1) (str.to_re "/")) (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "j") (re.++ (str.to_re "s") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.opt (re.++ (str.to_re "/") (str.to_re "n")))))))))))))))))))))) (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)