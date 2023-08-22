;test regex \\A\\b[A-Z]{1,2}[0-9][A-Z0-9]?( [0-9][ABD-HJLNP-UW-Z]{2})?\\b\\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\\") (re.++ (str.to_re "A") (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.++ (re.range "0" "9") (re.++ (re.opt (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (re.opt (re.++ (str.to_re " ") (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (re.range "D" "H") (re.union (str.to_re "J") (re.union (str.to_re "L") (re.union (str.to_re "N") (re.union (re.range "P" "U") (re.range "W" "Z")))))))))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (str.to_re "\\") (str.to_re "z"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)