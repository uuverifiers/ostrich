;test regex ((\d{1,5})*\.*(\d{0,3})&quot;[W|D|H|DIA][X|\s]).*
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* ((_ re.loop 1 5) (re.range "0" "9"))) (re.++ (re.* (str.to_re ".")) (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.++ (str.to_re "&") (re.++ (str.to_re "q") (re.++ (str.to_re "u") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re ";") (re.++ (re.union (str.to_re "W") (re.union (str.to_re "|") (re.union (str.to_re "D") (re.union (str.to_re "|") (re.union (str.to_re "H") (re.union (str.to_re "|") (re.union (str.to_re "D") (re.union (str.to_re "I") (str.to_re "A"))))))))) (re.union (str.to_re "X") (re.union (str.to_re "|") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))))))))) (re.* (re.diff re.allchar (str.to_re "\n"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)