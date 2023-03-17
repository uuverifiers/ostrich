;test regex \A\$2(a?)\$([0-9]{2})\$\n\t\t\t\t([./A-Za-z0-9]{22})([./A-Za-z0-9]{31})\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "$") (re.++ (str.to_re "2") (re.++ (re.opt (str.to_re "a")) (re.++ (str.to_re "$") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "$") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "\u{09}") (re.++ (str.to_re "\u{09}") (re.++ (str.to_re "\u{09}") (re.++ (str.to_re "\u{09}") (re.++ ((_ re.loop 22 22) (re.union (str.to_re ".") (re.union (str.to_re "/") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ ((_ re.loop 31 31) (re.union (str.to_re ".") (re.union (str.to_re "/") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))) (str.to_re "z")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)