;test regex ">\\s+((?:(?:[A-F0-9]{2}\\s+){5}[A-F0-9]{2}\\s*)+)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re ">") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "s")) (re.++ (re.+ (re.++ ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "F") (re.range "0" "9"))) (re.++ (str.to_re "\\") (re.+ (str.to_re "s"))))) (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "F") (re.range "0" "9"))) (re.++ (str.to_re "\\") (re.* (str.to_re "s")))))) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)