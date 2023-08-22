;test regex ^(NT|CallBack|SID|TimeOut)\s*\u{20}\s*[^\n]{512}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "N") (str.to_re "T")) (re.++ (str.to_re "C") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "B") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (str.to_re "k"))))))))) (re.++ (str.to_re "S") (re.++ (str.to_re "I") (str.to_re "D")))) (re.++ (str.to_re "T") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "O") (re.++ (str.to_re "u") (str.to_re "t")))))))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re "\u{20}") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) ((_ re.loop 512 512) (re.diff re.allchar (str.to_re "\u{0a}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)