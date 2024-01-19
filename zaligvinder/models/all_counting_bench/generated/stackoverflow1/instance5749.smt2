;test regex blocked\/([a-z]{1,3})\/?([a-zA-Z0-9]+)\/(.*)\/?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "b") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 3) (re.range "a" "z")) (re.++ (re.opt (str.to_re "/")) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (str.to_re "/") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.opt (str.to_re "/")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)