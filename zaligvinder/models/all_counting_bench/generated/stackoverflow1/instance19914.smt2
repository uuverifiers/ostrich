;test regex (([A-Z0-9]{1,4})[ \-]{1,3}|([Bb]lank)[ \-]{0,3})(([A-Z][a-z]+[.,;| ]?)+)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 3) (re.union (str.to_re " ") (str.to_re "-")))) (re.++ (re.++ (re.union (str.to_re "B") (str.to_re "b")) (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (str.to_re "k"))))) ((_ re.loop 0 3) (re.union (str.to_re " ") (str.to_re "-"))))) (re.+ (re.++ (re.range "A" "Z") (re.++ (re.+ (re.range "a" "z")) (re.opt (re.union (str.to_re ".") (re.union (str.to_re ",") (re.union (str.to_re ";") (re.union (str.to_re "|") (str.to_re " "))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)