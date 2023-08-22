;test regex (^[abcdjklmnpqrstwz](:?[a-z]{1,2})) [0-9]{1,4} *([a-z]{1})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (str.to_re "c") (re.union (str.to_re "d") (re.union (str.to_re "j") (re.union (str.to_re "k") (re.union (str.to_re "l") (re.union (str.to_re "m") (re.union (str.to_re "n") (re.union (str.to_re "p") (re.union (str.to_re "q") (re.union (str.to_re "r") (re.union (str.to_re "s") (re.union (str.to_re "t") (re.union (str.to_re "w") (str.to_re "z")))))))))))))))) (re.++ (re.opt (str.to_re ":")) ((_ re.loop 1 2) (re.range "a" "z"))))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (re.* (str.to_re " ")) ((_ re.loop 1 1) (re.range "a" "z"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)