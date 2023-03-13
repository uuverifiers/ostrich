;test regex ^.*?([^>]|[^l].|[^r].{2}|[^u].{3}|[^/].{4}|[^<].{5})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (re.union (re.union (re.union (re.union (re.diff re.allchar (str.to_re ">")) (re.++ (re.diff re.allchar (str.to_re "l")) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.diff re.allchar (str.to_re "r")) ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.diff re.allchar (str.to_re "u")) ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.diff re.allchar (str.to_re "/")) ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.diff re.allchar (str.to_re "<")) ((_ re.loop 5 5) (re.diff re.allchar (str.to_re "\n"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)