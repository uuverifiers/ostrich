;test regex ^(\d+)\. ?(.+?)(?:value|vlaue|balue|valie): ?(.+?)[\n\r]{2,}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (re.opt (str.to_re " ")) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (str.to_re "e"))))) (re.++ (str.to_re "v") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "u") (str.to_re "e")))))) (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (str.to_re "e")))))) (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (str.to_re "e")))))) (re.++ (str.to_re ":") (re.++ (re.opt (str.to_re " ")) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)