;test regex \[.*WORD([0-9]+)[0-9]{8,8}\]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "[") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "W") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "D") (re.++ (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "]"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)