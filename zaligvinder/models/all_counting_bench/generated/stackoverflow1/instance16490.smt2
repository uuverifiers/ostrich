;test regex sub("_\\d{8}.*", "", str1)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "_") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 8 8) (str.to_re "d")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}")))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (str.to_re "\u{22}"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (str.to_re "1"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)