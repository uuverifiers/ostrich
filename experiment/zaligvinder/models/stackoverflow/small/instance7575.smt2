;test regex ([XxYyWwHh]=\d+ ?){4}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 4 4) (re.++ (re.union (str.to_re "X") (re.union (str.to_re "x") (re.union (str.to_re "Y") (re.union (str.to_re "y") (re.union (str.to_re "W") (re.union (str.to_re "w") (re.union (str.to_re "H") (str.to_re "h")))))))) (re.++ (str.to_re "=") (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re " "))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)