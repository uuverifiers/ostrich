;test regex (?:\S+[ \t]+){0,2}my car
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 2) (re.++ (re.+ (re.inter (re.diff re.allchar (str.to_re "\u{20}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.inter (re.diff re.allchar (str.to_re "\u{0b}")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.inter (re.diff re.allchar (str.to_re "\u{09}")) (re.diff re.allchar (str.to_re "\u{0c}")))))))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))))) (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (str.to_re "r")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)