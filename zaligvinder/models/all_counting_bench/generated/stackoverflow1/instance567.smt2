;test regex ^(X{1},X{19})|(X{2},X{18})|...|(X{19},X{1})$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (str.to_re "X")) (re.++ (str.to_re ",") ((_ re.loop 19 19) (str.to_re "X"))))) (re.++ ((_ re.loop 2 2) (str.to_re "X")) (re.++ (str.to_re ",") ((_ re.loop 18 18) (str.to_re "X"))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.++ ((_ re.loop 19 19) (str.to_re "X")) (re.++ (str.to_re ",") ((_ re.loop 1 1) (str.to_re "X")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)