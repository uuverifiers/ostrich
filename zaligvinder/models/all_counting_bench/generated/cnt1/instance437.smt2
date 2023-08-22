;test regex pack-([0-9a-f]{40}).idx
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re "-") (re.++ ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "i") (re.++ (str.to_re "d") (str.to_re "x"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)