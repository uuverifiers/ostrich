;test regex (\[\d*\].*\[(SUCCESS|FAILURE)\]\s(s-.{3}).*(\r[\d\.]+){0,5})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "[") (re.++ (re.* (re.range "0" "9")) (re.++ (str.to_re "]") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "[") (re.++ (re.union (re.++ (str.to_re "S") (re.++ (str.to_re "U") (re.++ (str.to_re "C") (re.++ (str.to_re "C") (re.++ (str.to_re "E") (re.++ (str.to_re "S") (str.to_re "S"))))))) (re.++ (str.to_re "F") (re.++ (str.to_re "A") (re.++ (str.to_re "I") (re.++ (str.to_re "L") (re.++ (str.to_re "U") (re.++ (str.to_re "R") (str.to_re "E")))))))) (re.++ (str.to_re "]") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "-") ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 0 5) (re.++ (str.to_re "\u{0d}") (re.+ (re.union (re.range "0" "9") (str.to_re ".")))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)