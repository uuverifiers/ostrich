;test regex '^.+\-[kK][bB][0-9]{6,7}\-{0,1}[vV]{0,1}[0-9]{0,1}\-[xX][0-9]+.exe'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "-") (re.++ (re.union (str.to_re "k") (str.to_re "K")) (re.++ (re.union (str.to_re "b") (str.to_re "B")) (re.++ ((_ re.loop 6 7) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (str.to_re "-")) (re.++ ((_ re.loop 0 1) (re.union (str.to_re "v") (str.to_re "V"))) (re.++ ((_ re.loop 0 1) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.union (str.to_re "x") (str.to_re "X")) (re.++ (re.+ (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "e") (str.to_re "\u{27}"))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)