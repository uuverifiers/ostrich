;test regex ^([0-9a-fA-F]{8,16}) ([0-9a-fA-F]{8,16} )?[tTwW] (.*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 8 16) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ (str.to_re " ") (re.++ (re.opt (re.++ ((_ re.loop 8 16) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (str.to_re " "))) (re.++ (re.union (str.to_re "t") (re.union (str.to_re "T") (re.union (str.to_re "w") (str.to_re "W")))) (re.++ (str.to_re " ") (re.* (re.diff re.allchar (str.to_re "\n"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)