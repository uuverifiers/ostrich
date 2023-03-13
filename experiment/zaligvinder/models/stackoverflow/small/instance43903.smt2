;test regex ((DC\d{2}[-]\d{2}[-]\d{2})|(MB\d{2}[-]\d{2}[-]\d{2})|(CN0\d{1})|(SYSA)|(ppag)|(METR))
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "D") (re.++ (str.to_re "C") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))))))) (re.++ (str.to_re "M") (re.++ (str.to_re "B") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))))))))) (re.++ (str.to_re "C") (re.++ (str.to_re "N") (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "0" "9")))))) (re.++ (str.to_re "S") (re.++ (str.to_re "Y") (re.++ (str.to_re "S") (str.to_re "A"))))) (re.++ (str.to_re "p") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (str.to_re "g"))))) (re.++ (str.to_re "M") (re.++ (str.to_re "E") (re.++ (str.to_re "T") (str.to_re "R")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)