;test regex Regexp("((\\b\\w{1,15}\\b)([\\s]+)?){1,4}\\z").matches(bs)?.last
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 1 4) (re.++ (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 15) (str.to_re "w")) (re.++ (str.to_re "\\") (str.to_re "b")))))) (re.opt (re.+ (re.union (str.to_re "\\") (str.to_re "s")))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "z") (str.to_re "\u{22}"))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (re.opt (re.++ (str.to_re "b") (str.to_re "s"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (str.to_re "t")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)