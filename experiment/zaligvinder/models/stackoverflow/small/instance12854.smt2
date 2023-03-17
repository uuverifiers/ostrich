;test regex sub("^(([^.]+\\.){2}).*", "\\1", "HG.1T.11")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.++ (re.+ (re.diff re.allchar (str.to_re "."))) (re.++ (str.to_re "\\") (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (str.to_re "\u{22}"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "H") (re.++ (str.to_re "G") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "1") (re.++ (str.to_re "T") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "11") (str.to_re "\u{22}")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)