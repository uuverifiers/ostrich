;test regex ^localhost$|^127(?:\.[0-9]+){0,2}\.[0-9]+$|^(?:0*\:)*?:?0*1$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "s") (str.to_re "t")))))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "127") (re.++ ((_ re.loop 0 2) (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.++ (re.* (str.to_re "0")) (str.to_re ":"))) (re.++ (re.opt (str.to_re ":")) (re.++ (re.* (str.to_re "0")) (str.to_re "1"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)