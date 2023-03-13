;test regex ^(?:[^-]|-(?:[^cw].?|c[^l]|w[^fl])-|-.{2}[^-])*_thanks
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.union (re.union (re.diff re.allchar (str.to_re "-")) (re.++ (str.to_re "-") (re.++ (re.union (re.union (re.++ (re.inter (re.diff re.allchar (str.to_re "c")) (re.diff re.allchar (str.to_re "w"))) (re.opt (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "c") (re.diff re.allchar (str.to_re "l")))) (re.++ (str.to_re "w") (re.inter (re.diff re.allchar (str.to_re "f")) (re.diff re.allchar (str.to_re "l"))))) (str.to_re "-")))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.diff re.allchar (str.to_re "-")))))) (re.++ (str.to_re "_") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "k") (str.to_re "s")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)