;test regex (.*id\=ticket.*)(&sys_id=(\w|\d){32})($|\&.*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))) (re.++ (re.++ (str.to_re "&") (re.++ (str.to_re "s") (re.++ (str.to_re "y") (re.++ (str.to_re "s") (re.++ (str.to_re "_") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") ((_ re.loop 32 32) (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.range "0" "9"))))))))))) (re.union (str.to_re "") (re.++ (str.to_re "&") (re.* (re.diff re.allchar (str.to_re "\n")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)