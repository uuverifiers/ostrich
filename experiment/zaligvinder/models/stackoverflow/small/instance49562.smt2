;test regex ([A-z]+[_ ]\d+[_]{2}[c][.][A-z]+[_ ]\d+[_]{2}[c])
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.range "A" "z")) (re.++ (re.union (str.to_re "_") (str.to_re " ")) (re.++ (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (str.to_re "_")) (re.++ (str.to_re "c") (re.++ (str.to_re ".") (re.++ (re.+ (re.range "A" "z")) (re.++ (re.union (str.to_re "_") (str.to_re " ")) (re.++ (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (str.to_re "_")) (str.to_re "c")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)