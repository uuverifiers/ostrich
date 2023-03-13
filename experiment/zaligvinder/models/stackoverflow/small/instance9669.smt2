;test regex ^(0?[0-9]{0,4}(?:\.\d+)?|1\d{4}(?:\.\d+)?|20[0-4][0-7][0-8](?:\.\d+)?|20479(?:\.[0-7])?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (re.opt (str.to_re "0")) (re.++ ((_ re.loop 0 4) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (re.++ (str.to_re "1") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))))) (re.++ (str.to_re "20") (re.++ (re.range "0" "4") (re.++ (re.range "0" "7") (re.++ (re.range "0" "8") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))))))) (re.++ (str.to_re "20479") (re.opt (re.++ (str.to_re ".") (re.range "0" "7")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)