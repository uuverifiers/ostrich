;test regex ([0-9]{1,4}?.*?|.*[0-9]{4}.?|.*?)([Ss]?[0-9].+?[Ee]?[0-9]+?)([^0-9].+$)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.diff re.allchar (str.to_re "\n")))))) (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.++ (re.opt (re.union (str.to_re "S") (str.to_re "s"))) (re.++ (re.range "0" "9") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.opt (re.union (str.to_re "E") (str.to_re "e"))) (re.+ (re.range "0" "9")))))) (re.++ (re.++ (re.diff re.allchar (re.range "0" "9")) (re.+ (re.diff re.allchar (str.to_re "\n")))) (str.to_re ""))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)