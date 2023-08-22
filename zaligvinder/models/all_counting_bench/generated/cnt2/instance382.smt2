;test regex \A\$2a?\$\d\d\$[./0-9A-Za-z]{53}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "$") (re.++ (str.to_re "2") (re.++ (re.opt (str.to_re "a")) (re.++ (str.to_re "$") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re "$") ((_ re.loop 53 53) (re.union (str.to_re ".") (re.union (str.to_re "/") (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)