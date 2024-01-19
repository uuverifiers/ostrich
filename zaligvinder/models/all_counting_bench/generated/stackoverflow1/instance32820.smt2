;test regex sub("\\s+(N(\\S+\\s+){1,}|)\\S*DER$", "", a)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "s")) (re.++ (re.union (re.++ (str.to_re "") (re.++ (str.to_re "N") (re.++ (re.* (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "S")) (re.++ (str.to_re "\\") (re.+ (str.to_re "s")))))) ((_ re.loop 1 1) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "S")) (re.++ (str.to_re "\\") (re.+ (str.to_re "s"))))))))) (str.to_re "")) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "S")) (re.++ (str.to_re "D") (re.++ (str.to_re "E") (str.to_re "R"))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (str.to_re "\u{22}"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "a")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)