;test regex ([0-9])(\})([A-Z]{3})(\})([0-9][A-Z]{2}[0-9])(\})([0-9])(\s\-)([A-Z])(\})([0-9]).
(declare-const X String)
(assert (str.in_re X (re.++ (re.range "0" "9") (re.++ (str.to_re "}") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ (str.to_re "}") (re.++ (re.++ (re.range "0" "9") (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.range "0" "9"))) (re.++ (str.to_re "}") (re.++ (re.range "0" "9") (re.++ (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (str.to_re "-")) (re.++ (re.range "A" "Z") (re.++ (str.to_re "}") (re.++ (re.range "0" "9") (re.diff re.allchar (str.to_re "\n")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)