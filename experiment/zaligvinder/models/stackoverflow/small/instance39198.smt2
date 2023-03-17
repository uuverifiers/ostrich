;test regex sub("(:.*){2}", "", "2016-12-31T18:31:34Z")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 2 2) (re.++ (str.to_re ":") (re.* (re.diff re.allchar (str.to_re "\n"))))) (str.to_re "\u{22}"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (str.to_re "\u{22}"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "2016") (re.++ (str.to_re "-") (re.++ (str.to_re "12") (re.++ (str.to_re "-") (re.++ (str.to_re "31") (re.++ (str.to_re "T") (re.++ (str.to_re "18") (re.++ (str.to_re ":") (re.++ (str.to_re "31") (re.++ (str.to_re ":") (re.++ (str.to_re "34") (re.++ (str.to_re "Z") (str.to_re "\u{22}"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)