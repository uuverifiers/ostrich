;test regex \A\{.*\}([0-9a-fA-F]{32})([!-~]{32})\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "{") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "}") (re.++ ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ ((_ re.loop 32 32) (re.union (str.to_re "!") (re.union (str.to_re "-") (str.to_re "~")))) (str.to_re "z")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)