;test regex ([^/]+)/10[A|a]([0-9]+)[A|a]{0,1}.aspx[\?]*([^/]*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.diff re.allchar (str.to_re "/"))) (re.++ (str.to_re "/") (re.++ (str.to_re "10") (re.++ (re.union (str.to_re "A") (re.union (str.to_re "|") (str.to_re "a"))) (re.++ (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (re.union (str.to_re "A") (re.union (str.to_re "|") (str.to_re "a")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "x") (re.++ (re.* (str.to_re "?")) (re.* (re.diff re.allchar (str.to_re "/")))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)