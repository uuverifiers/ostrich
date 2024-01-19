;test regex (^[ \t]*//[^/].*\r?\n){3,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ (str.to_re "") (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}"))) (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.diff re.allchar (str.to_re "/")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))))))) ((_ re.loop 3 3) (re.++ (str.to_re "") (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}"))) (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.diff re.allchar (str.to_re "/")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)