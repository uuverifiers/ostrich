;test regex -+(\s+)?Report(\s+)?-+\n(.*\n)+\n-{72}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (str.to_re "-")) (re.++ (re.opt (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "t") (re.++ (re.opt (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.++ (re.+ (str.to_re "-")) (re.++ (str.to_re "\u{0a}") (re.++ (re.+ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 72 72) (str.to_re "-")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)