;test regex "[ ,]*[0-9]{1,3}\s{0,1}(/|-|bt.)\s{0,1}[0-9]{1,3} "
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.union (str.to_re " ") (str.to_re ","))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.union (re.union (str.to_re "/") (str.to_re "-")) (re.++ (str.to_re "b") (re.++ (str.to_re "t") (re.diff re.allchar (str.to_re "\n"))))) (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re " ") (str.to_re "\u{22}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)