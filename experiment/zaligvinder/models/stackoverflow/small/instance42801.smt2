;test regex ^Biography(?:.*\n)+(?:\n){3}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "B") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "p") (re.++ (str.to_re "h") (re.++ (str.to_re "y") (re.++ (re.+ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}"))) ((_ re.loop 3 3) (str.to_re "\u{0a}")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)