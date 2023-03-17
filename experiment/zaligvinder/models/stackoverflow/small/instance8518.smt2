;test regex (?:wind|temp|press)[^0-9]{0,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "w") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "d")))) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (str.to_re "p"))))) (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (str.to_re "s")))))) (re.++ (re.* (re.diff re.allchar (re.range "0" "9"))) ((_ re.loop 0 0) (re.diff re.allchar (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)