;test regex  ( (?:b?c)? (?:abc){2,} (?:ab?)? ) 
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re " ") (re.++ (re.opt (re.++ (re.opt (str.to_re "b")) (str.to_re "c"))) (re.++ (str.to_re " ") (re.++ (re.++ (re.* (re.++ (str.to_re "a") (re.++ (str.to_re "b") (str.to_re "c")))) ((_ re.loop 2 2) (re.++ (str.to_re "a") (re.++ (str.to_re "b") (str.to_re "c"))))) (re.++ (str.to_re " ") (re.++ (re.opt (re.++ (str.to_re "a") (re.opt (str.to_re "b")))) (str.to_re " "))))))) (str.to_re " ")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)