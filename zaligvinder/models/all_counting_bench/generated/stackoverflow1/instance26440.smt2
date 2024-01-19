;test regex .*\/[a-z0-9]{0,}\.gif\?abc=[0-9]&rnd=([0-9]{1,}.*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "/") (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 0 0) (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (str.to_re "g") (re.++ (str.to_re "i") (re.++ (str.to_re "f") (re.++ (str.to_re "?") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re "=") (re.++ (re.range "0" "9") (re.++ (str.to_re "&") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)