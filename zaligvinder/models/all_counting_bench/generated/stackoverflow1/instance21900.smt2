;test regex (\\s?[" + alphabet + "]{9,9})+
(declare-const X String)
(assert (str.in_re X (re.+ (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) ((_ re.loop 9 9) (re.union (str.to_re "\u{22}") (re.union (str.to_re " ") (re.union (str.to_re "+") (re.union (str.to_re " ") (re.union (str.to_re "a") (re.union (str.to_re "l") (re.union (str.to_re "p") (re.union (str.to_re "h") (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (str.to_re "e") (re.union (str.to_re "t") (re.union (str.to_re " ") (re.union (str.to_re "+") (re.union (str.to_re " ") (str.to_re "\u{22}"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)