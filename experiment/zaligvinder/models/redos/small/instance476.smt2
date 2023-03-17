;test regex s\.setAttribute\('value', '([a-f0-9]{40})'\);
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re ".") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "A") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "b") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "(") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (str.to_re "\u{27}")))))))))))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "\u{27}") (re.++ (str.to_re ")") (str.to_re ";"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)