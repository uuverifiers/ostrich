;test regex ^skit1 \([0-9a-f]{40}\) \[TAG=v1\]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "s") (re.++ (str.to_re "k") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "(") (re.++ ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re ")") (re.++ (str.to_re " ") (re.++ (str.to_re "[") (re.++ (str.to_re "T") (re.++ (str.to_re "A") (re.++ (str.to_re "G") (re.++ (str.to_re "=") (re.++ (str.to_re "v") (re.++ (str.to_re "1") (str.to_re "]"))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)