;test regex .*(\d{1,2})(?:\s)?(min|m|hour|hr|h|minutes|minute)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "m") (re.++ (str.to_re "i") (str.to_re "n"))) (str.to_re "m")) (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (str.to_re "r"))))) (re.++ (str.to_re "h") (str.to_re "r"))) (str.to_re "h")) (re.++ (str.to_re "m") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (str.to_re "s")))))))) (re.++ (str.to_re "m") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (str.to_re "e"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)