;test regex replaceAll("[-]*\\b[\\w]{1,3}\\b[-]*"," ");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re "A") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (re.* (str.to_re "-")) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ ((_ re.loop 1 3) (re.union (str.to_re "\\") (str.to_re "w"))) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (re.* (str.to_re "-")) (str.to_re "\u{22}"))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (str.to_re "\u{22}"))))) (str.to_re ";"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)