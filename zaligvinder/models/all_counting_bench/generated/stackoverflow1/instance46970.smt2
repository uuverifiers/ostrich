;test regex (\d{1,2}h)|(\d{1,2}:\d{2})|(\d{1,2}(am|pm))\gi
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "h")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ":") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "a") (str.to_re "m")) (re.++ (str.to_re "p") (str.to_re "m")))) (re.++ (str.to_re "g") (str.to_re "i"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)