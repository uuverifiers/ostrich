;test regex =REGEXEXTRACT(A1,"[+-]?([0-9]*[.])?[0-9]+{6,}")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "=") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re "A") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (re.++ (str.to_re "A") (str.to_re "1")) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{22}") (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.++ (re.opt (re.++ (re.* (re.range "0" "9")) (str.to_re "."))) (re.++ (re.++ (re.* (re.+ (re.range "0" "9"))) ((_ re.loop 6 6) (re.+ (re.range "0" "9")))) (str.to_re "\u{22}"))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)