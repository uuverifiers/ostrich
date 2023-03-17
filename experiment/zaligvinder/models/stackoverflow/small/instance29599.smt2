;test regex (?:GTSET|GP0|GPP|L0)\|#0[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]*\|(.*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.++ (str.to_re "G") (re.++ (str.to_re "T") (re.++ (str.to_re "S") (re.++ (str.to_re "E") (str.to_re "T"))))) (re.++ (str.to_re "G") (re.++ (str.to_re "P") (str.to_re "0")))) (re.++ (str.to_re "G") (re.++ (str.to_re "P") (str.to_re "P")))) (re.++ (str.to_re "L") (str.to_re "0"))) (re.++ (str.to_re "|") (re.++ (str.to_re "#") (re.++ (str.to_re "0") (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") (re.++ (re.* (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "|") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)