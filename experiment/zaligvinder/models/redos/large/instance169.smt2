;test regex .{84}.*\\u{20}[wW]\u{20}[iI]\u{20}[nN]\u{20}[rR]\u{20}[eE]\u{20}[gG]\u{20}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 84 84) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\\") (re.++ (str.to_re "x") (re.++ (str.to_re "20") (re.++ (re.union (str.to_re "w") (str.to_re "W")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "i") (str.to_re "I")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "n") (str.to_re "N")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "r") (str.to_re "R")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "g") (str.to_re "G")) (str.to_re "\u{20}")))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)