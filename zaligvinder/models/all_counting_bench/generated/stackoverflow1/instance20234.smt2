;test regex h[hypenatd]{0,9}(-\s*\n*\s)?[hypenatd]{0,9}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ ((_ re.loop 0 9) (re.union (str.to_re "h") (re.union (str.to_re "y") (re.union (str.to_re "p") (re.union (str.to_re "e") (re.union (str.to_re "n") (re.union (str.to_re "a") (re.union (str.to_re "t") (str.to_re "d"))))))))) (re.++ (re.opt (re.++ (str.to_re "-") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.* (str.to_re "\u{0a}")) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))) ((_ re.loop 0 9) (re.union (str.to_re "h") (re.union (str.to_re "y") (re.union (str.to_re "p") (re.union (str.to_re "e") (re.union (str.to_re "n") (re.union (str.to_re "a") (re.union (str.to_re "t") (str.to_re "d"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)