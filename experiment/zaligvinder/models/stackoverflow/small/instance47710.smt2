;test regex (\d{2})-(\d{2})-(\d{2}) (\d{2}):(\d{2})([AP]M) (<DIR>|\d+) (.+)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.++ (re.union (str.to_re "A") (str.to_re "P")) (str.to_re "M")) (re.++ (str.to_re " ") (re.++ (re.union (re.++ (str.to_re "<") (re.++ (str.to_re "D") (re.++ (str.to_re "I") (re.++ (str.to_re "R") (str.to_re ">"))))) (re.+ (re.range "0" "9"))) (re.++ (str.to_re " ") (re.+ (re.diff re.allchar (str.to_re "\n"))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)