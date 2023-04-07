;test regex \[color=#[0-9a-f]{6}\]
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "[") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "=") (re.++ (str.to_re "#") (re.++ ((_ re.loop 6 6) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "]"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)