;test regex junk <- gsubfn('(([A-Z]\\s+){2,}[A-Z])', ~ print(list(...)), x)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "j") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.++ (str.to_re "k") (re.++ (str.to_re " ") (re.++ (str.to_re "<") (re.++ (str.to_re "-") (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "f") (re.++ (str.to_re "n") (re.++ (re.++ (re.++ (str.to_re "\u{27}") (re.++ (re.++ (re.++ (re.* (re.++ (re.range "A" "Z") (re.++ (str.to_re "\\") (re.+ (str.to_re "s"))))) ((_ re.loop 2 2) (re.++ (re.range "A" "Z") (re.++ (str.to_re "\\") (re.+ (str.to_re "s")))))) (re.range "A" "Z")) (str.to_re "\u{27}"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n")))))))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "x"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)