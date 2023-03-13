;test regex ^https?:\/\/www\.chkhikvadze\.com\/[-a-z0-9/]+-[0-9]\.[0-9]{7}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "w") (re.++ (str.to_re "w") (re.++ (str.to_re "w") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "k") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (re.++ (str.to_re "k") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re "z") (re.++ (str.to_re "e") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "/") (re.++ (re.+ (re.union (str.to_re "-") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "/"))))) (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (str.to_re ".") ((_ re.loop 7 7) (re.range "0" "9"))))))))))))))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)