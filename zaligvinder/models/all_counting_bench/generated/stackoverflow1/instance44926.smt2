;test regex sub('a[ab]b{1,2}\\Ka', 'i', ba, perl=T)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "a") (re.++ (re.union (str.to_re "a") (str.to_re "b")) (re.++ ((_ re.loop 1 2) (str.to_re "b")) (re.++ (str.to_re "\\") (re.++ (str.to_re "K") (re.++ (str.to_re "a") (str.to_re "\u{27}")))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "i") (str.to_re "\u{27}")))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (str.to_re "a"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (re.++ (str.to_re "=") (str.to_re "T"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)