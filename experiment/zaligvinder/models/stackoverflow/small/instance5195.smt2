;test regex sub("^\\d+(?:/\\d+){2}\\s+(\\d+):(\\d+):\\d+$","\\1\\2", s)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "/") (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))))) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "s")) (re.++ (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))) (re.++ (str.to_re ":") (re.++ (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))) (re.++ (str.to_re ":") (re.++ (str.to_re "\\") (re.+ (str.to_re "d")))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (re.++ (str.to_re "\\") (re.++ (str.to_re "2") (str.to_re "\u{22}")))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "s")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)