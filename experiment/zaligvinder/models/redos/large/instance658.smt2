;test regex ^QL([NDR])(.{12})(.{48})(.)([BSPRID ])(.{8})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "Q") (re.++ (str.to_re "L") (re.++ (re.union (str.to_re "N") (re.union (str.to_re "D") (str.to_re "R"))) (re.++ ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 48 48) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.union (str.to_re "B") (re.union (str.to_re "S") (re.union (str.to_re "P") (re.union (str.to_re "R") (re.union (str.to_re "I") (re.union (str.to_re "D") (str.to_re " "))))))) ((_ re.loop 8 8) (re.diff re.allchar (str.to_re "\n"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)