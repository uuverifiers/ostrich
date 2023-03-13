;test regex "<\?/php/n//\{\{[:alnum:]{8}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "<") (re.++ (str.to_re "?") (re.++ (str.to_re "/") (re.++ (str.to_re "p") (re.++ (str.to_re "h") (re.++ (str.to_re "p") (re.++ (str.to_re "/") (re.++ (str.to_re "n") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "{") (re.++ (str.to_re "{") (re.++ ((_ re.loop 8 8) (re.union (str.to_re ":") (re.union (str.to_re "a") (re.union (str.to_re "l") (re.union (str.to_re "n") (re.union (str.to_re "u") (re.union (str.to_re "m") (str.to_re ":")))))))) (str.to_re "\u{22}")))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)