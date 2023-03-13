;test regex ^magnet:\?xt=urn:[a-z0-9]+:[a-z0-9]{32,40}&dn=.+&tr=.+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re ":") (re.++ (str.to_re "?") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re "=") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re ":") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re ":") (re.++ ((_ re.loop 32 40) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "&") (re.++ (str.to_re "d") (re.++ (str.to_re "n") (re.++ (str.to_re "=") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "&") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "=") (re.+ (re.diff re.allchar (str.to_re "\n"))))))))))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)