;test regex [/^SMTP$/]{4}|[/^THROTTLED$/]{9}
(declare-const X String)
(assert (str.in_re X (re.union ((_ re.loop 4 4) (re.union (str.to_re "/") (re.union (str.to_re "^") (re.union (str.to_re "S") (re.union (str.to_re "M") (re.union (str.to_re "T") (re.union (str.to_re "P") (re.union (str.to_re "$") (str.to_re "/"))))))))) ((_ re.loop 9 9) (re.union (str.to_re "/") (re.union (str.to_re "^") (re.union (str.to_re "T") (re.union (str.to_re "H") (re.union (str.to_re "R") (re.union (str.to_re "O") (re.union (str.to_re "T") (re.union (str.to_re "T") (re.union (str.to_re "L") (re.union (str.to_re "E") (re.union (str.to_re "D") (re.union (str.to_re "$") (str.to_re "/")))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)