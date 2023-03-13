;test regex \n(X-Habeas-SWE-1:.{0,512}X-Habeas-SWE-9:[^\n]{0,64}\n)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "X") (re.++ (str.to_re "-") (re.++ (str.to_re "H") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "-") (re.++ (str.to_re "S") (re.++ (str.to_re "W") (re.++ (str.to_re "E") (re.++ (str.to_re "-") (re.++ (str.to_re "1") (re.++ (str.to_re ":") (re.++ ((_ re.loop 0 512) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "X") (re.++ (str.to_re "-") (re.++ (str.to_re "H") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "-") (re.++ (str.to_re "S") (re.++ (str.to_re "W") (re.++ (str.to_re "E") (re.++ (str.to_re "-") (re.++ (str.to_re "9") (re.++ (str.to_re ":") (re.++ ((_ re.loop 0 64) (re.diff re.allchar (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)