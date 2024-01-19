;test regex val pattern="\\d+((\\.\\d{3}+)?(,\\d{1,2}+)?|(,\\d{3}+)?(\\.\\d{1,2}+)?)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (re.++ (re.union (re.++ (re.opt (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.+ ((_ re.loop 3 3) (str.to_re "d"))))))) (re.opt (re.++ (str.to_re ",") (re.++ (str.to_re "\\") (re.+ ((_ re.loop 1 2) (str.to_re "d"))))))) (re.++ (re.opt (re.++ (str.to_re ",") (re.++ (str.to_re "\\") (re.+ ((_ re.loop 3 3) (str.to_re "d")))))) (re.opt (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.+ ((_ re.loop 1 2) (str.to_re "d"))))))))) (str.to_re "\u{22}")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)