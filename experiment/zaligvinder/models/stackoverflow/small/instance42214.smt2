;test regex H(\d{7})_([\d\w]*)\n([\n\w\.]*?)V($b)_(\d)_(\d)_(\d*)(_([a-z_\d]*)($c)($c))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "H") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (re.* (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))) (re.++ (str.to_re "\u{0a}") (re.++ (re.* (re.union (str.to_re "\u{0a}") (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re ".")))) (re.++ (str.to_re "V") (re.++ (re.++ (str.to_re "") (str.to_re "b")) (re.++ (str.to_re "_") (re.++ (re.range "0" "9") (re.++ (str.to_re "_") (re.++ (re.range "0" "9") (re.++ (str.to_re "_") (re.++ (re.* (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (re.* (re.union (re.range "a" "z") (re.union (str.to_re "_") (re.range "0" "9")))) (re.++ (re.++ (str.to_re "") (str.to_re "c")) (re.++ (str.to_re "") (str.to_re "c")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)