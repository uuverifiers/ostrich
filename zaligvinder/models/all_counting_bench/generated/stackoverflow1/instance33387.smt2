;test regex sub(".{12}(\\d+_).{8}(\\d+).{4}", "\\1\\2", str1)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (str.to_re "_"))) (re.++ ((_ re.loop 8 8) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))) (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (re.++ (str.to_re "\\") (re.++ (str.to_re "2") (str.to_re "\u{22}"))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (str.to_re "1"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)