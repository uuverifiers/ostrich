;test regex \A\$5\$[a-zA-Z0-9./]{16}\$[a-zA-Z0-9./]{43}\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "$") (re.++ (str.to_re "5") (re.++ (str.to_re "$") (re.++ ((_ re.loop 16 16) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "/")))))) (re.++ (str.to_re "$") (re.++ ((_ re.loop 43 43) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "/")))))) (str.to_re "z"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)