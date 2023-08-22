;test regex sub('(.{2})(.{1})(.{3})', "\\1\\20\\3", f)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 1 1) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{27}"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (re.++ (str.to_re "\\") (re.++ (str.to_re "20") (re.++ (str.to_re "\\") (re.++ (str.to_re "3") (str.to_re "\u{22}"))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "f")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)