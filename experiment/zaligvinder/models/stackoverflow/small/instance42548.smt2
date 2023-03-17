;test regex ([A-Za-z ]*) ([0-9]{7}) (?:\(([0-9]{2})\) )?on ([A-Za-z0-9: ]*) \(([0-9]*)\)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.opt (re.++ (str.to_re "(") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ")") (str.to_re " "))))) (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re ":") (str.to_re " ")))))) (re.++ (str.to_re " ") (re.++ (str.to_re "(") (re.++ (re.* (re.range "0" "9")) (str.to_re ")")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)