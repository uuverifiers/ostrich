;test regex \r\nAuthorization\u{3a}\s*Basic[^\n]{256}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "A") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "z") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "\u{3a}") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re "B") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "c") ((_ re.loop 256 256) (re.diff re.allchar (str.to_re "\u{0a}")))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)