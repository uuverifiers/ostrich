;test regex $p .= '[^"]*"\s*>(.*?)</a>(.{0,5})%imm';
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (re.* (re.diff re.allchar (str.to_re "\u{22}"))) (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re ">") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (re.++ (str.to_re ">") (re.++ ((_ re.loop 0 5) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "%") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (str.to_re "m") (re.++ (str.to_re "\u{27}") (str.to_re ";")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)