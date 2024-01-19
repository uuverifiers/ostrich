;test regex '#(^|\s){1}('. $needle .')($|\s|,|\.){1}#i'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "#") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "") (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.++ (re.++ (re.++ (str.to_re "\u{27}") (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re " "))) (re.++ (str.to_re "") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{27}"))))))))))) (re.++ ((_ re.loop 1 1) (re.union (re.union (re.union (str.to_re "") (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (str.to_re ",")) (str.to_re "."))) (re.++ (str.to_re "#") (re.++ (str.to_re "i") (str.to_re "\u{27}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)