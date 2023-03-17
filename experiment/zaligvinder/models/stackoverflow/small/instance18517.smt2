;test regex s.replace(/^(.+)$\r?\n={3,}/gm, '<h1>$1</h1>')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (re.++ (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.+ (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "\u{0d}")) (re.++ (str.to_re "\u{0a}") (re.++ (re.++ (re.* (str.to_re "=")) ((_ re.loop 3 3) (str.to_re "="))) (re.++ (str.to_re "/") (re.++ (str.to_re "g") (str.to_re "m")))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "<") (re.++ (str.to_re "h") (re.++ (str.to_re "1") (str.to_re ">")))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "h") (re.++ (str.to_re "1") (re.++ (str.to_re ">") (str.to_re "\u{27}"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)