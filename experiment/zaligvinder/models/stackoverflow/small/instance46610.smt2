;test regex !(https?://)?([-_a-z0-9]+\.)*([-_a-z0-9]+)\.([a-z]{2,4})(/?)(.*)!i
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "!") (re.++ (re.opt (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (str.to_re "/"))))))))) (re.++ (re.* (re.++ (re.+ (re.union (str.to_re "-") (re.union (str.to_re "_") (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re "."))) (re.++ (re.+ (re.union (str.to_re "-") (re.union (str.to_re "_") (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 2 4) (re.range "a" "z")) (re.++ (re.opt (str.to_re "/")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "!") (str.to_re "i"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)