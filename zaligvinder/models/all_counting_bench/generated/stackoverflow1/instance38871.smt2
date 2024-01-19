;test regex gsub('\\b\\w{1,2}\\s','',str)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 2) (str.to_re "w")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (str.to_re "\u{27}")))))))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (str.to_re "\u{27}")))) (re.++ (str.to_re ",") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (str.to_re "r")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)