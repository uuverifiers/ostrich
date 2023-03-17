;test regex (?:https?:\/\/|\/[a-z]{2}_[A-Z]{2}|[?&]tic=[^&?]*)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (str.to_re "/")))))))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "_") ((_ re.loop 2 2) (re.range "A" "Z")))))) (re.++ (re.union (str.to_re "?") (str.to_re "&")) (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "=") (re.* (re.inter (re.diff re.allchar (str.to_re "&")) (re.diff re.allchar (str.to_re "?"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)