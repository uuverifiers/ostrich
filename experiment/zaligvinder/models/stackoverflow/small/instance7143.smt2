;test regex sub("(.*[a-z]{1}) ([0-9.]+\\s*-?\\s*[0-9.]*\\s*[a-z]*\\s*)$", "\\2 \\1", x)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 1 1) (re.range "a" "z"))) (re.++ (str.to_re " ") (re.++ (re.+ (re.union (re.range "0" "9") (str.to_re "."))) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (re.opt (str.to_re "-")) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (re.* (re.union (re.range "0" "9") (str.to_re "."))) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (re.* (re.range "a" "z")) (re.++ (str.to_re "\\") (re.* (str.to_re "s")))))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "2") (re.++ (str.to_re " ") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (str.to_re "\u{22}")))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "x")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)