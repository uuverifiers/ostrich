;test regex \"adr\":\"([^"]+)\",\"state\":\"[0-9A-Fa-f]{2}:FE\"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re "r") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re ":") (re.++ (str.to_re "\u{22}") (re.++ (re.+ (re.diff re.allchar (str.to_re "\u{22}"))) (str.to_re "\u{22}"))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re ":") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f")))) (re.++ (str.to_re ":") (re.++ (str.to_re "F") (re.++ (str.to_re "E") (str.to_re "\u{22}"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)