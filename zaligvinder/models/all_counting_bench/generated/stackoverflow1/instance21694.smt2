;test regex gsub('(.{1,20})', '\\1\n',nif)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 1 20) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{27}"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (re.++ (str.to_re "\u{0a}") (str.to_re "\u{27}")))))))) (re.++ (str.to_re ",") (re.++ (str.to_re "n") (re.++ (str.to_re "i") (str.to_re "f")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)