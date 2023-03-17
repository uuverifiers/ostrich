;test regex gsub("^\\s;\\s|;\\s{2}", "", Days$BestDays)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.union (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ (str.to_re ";") (re.++ (str.to_re "\\") (str.to_re "s"))))))) (re.++ (re.++ (re.++ (re.++ (str.to_re ";") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (str.to_re "s")) (str.to_re "\u{22}")))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (str.to_re "\u{22}"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "y") (str.to_re "s"))))))) (re.++ (str.to_re "") (re.++ (str.to_re "B") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "y") (str.to_re "s")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)