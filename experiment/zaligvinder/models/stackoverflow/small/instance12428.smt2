;test regex (e10200_400_800_)(.*?)(_[0-9]{6})?+(.*?)?-(prod|stdeb)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "e") (re.++ (str.to_re "10200") (re.++ (str.to_re "_") (re.++ (str.to_re "400") (re.++ (str.to_re "_") (re.++ (str.to_re "800") (str.to_re "_"))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.+ (re.opt (re.++ (str.to_re "_") ((_ re.loop 6 6) (re.range "0" "9"))))) (re.++ (re.opt (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "-") (re.union (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (str.to_re "d")))) (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (str.to_re "b")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)