;test regex \d{17}_foo_\d{14}_00000.warc.open
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 17 17) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (str.to_re "_") (re.++ ((_ re.loop 14 14) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "00000") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "w") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "c") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "o") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (str.to_re "n")))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)