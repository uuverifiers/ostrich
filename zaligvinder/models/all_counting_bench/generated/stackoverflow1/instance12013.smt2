;test regex ((<p|<span)[^])(style{1}={1}"{1}[^"]+"{1})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (re.++ (str.to_re "<") (str.to_re "p")) (re.++ (str.to_re "<") (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (str.to_re "n")))))) (str.to_re "^")) (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "y") (re.++ (str.to_re "l") (re.++ ((_ re.loop 1 1) (str.to_re "e")) (re.++ ((_ re.loop 1 1) (str.to_re "=")) (re.++ ((_ re.loop 1 1) (str.to_re "\u{22}")) (re.++ (re.+ (re.diff re.allchar (str.to_re "\u{22}"))) ((_ re.loop 1 1) (str.to_re "\u{22}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)