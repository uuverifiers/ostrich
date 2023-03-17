;test regex [a-z]{1}[a-z0-9\-_\.]{2,24}@tlen\.pl
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "a" "z")) (re.++ ((_ re.loop 2 24) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "-") (re.union (str.to_re "_") (str.to_re ".")))))) (re.++ (str.to_re "@") (re.++ (str.to_re "t") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re ".") (re.++ (str.to_re "p") (str.to_re "l"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)