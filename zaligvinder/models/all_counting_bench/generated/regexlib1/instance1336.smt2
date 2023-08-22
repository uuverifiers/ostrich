;test regex ^((\-|d|l|p|s){1}(\-|r|w|x){9})$ 
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (re.union (re.union (re.union (str.to_re "-") (str.to_re "d")) (str.to_re "l")) (str.to_re "p")) (str.to_re "s"))) ((_ re.loop 9 9) (re.union (re.union (re.union (str.to_re "-") (str.to_re "r")) (str.to_re "w")) (str.to_re "x"))))) (re.++ (str.to_re "") (str.to_re " ")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)