;test regex ^(V|R|E)\t([0-9]{12}Z)\t([0-9]{12}Z)?\t([0-9a-fA-F]{2,})\t([^\t]+)\t(.+)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.union (str.to_re "V") (str.to_re "R")) (str.to_re "E")) (re.++ (str.to_re "\u{09}") (re.++ (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "Z")) (re.++ (str.to_re "\u{09}") (re.++ (re.opt (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "Z"))) (re.++ (str.to_re "\u{09}") (re.++ (re.++ (re.* (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F"))))) (re.++ (str.to_re "\u{09}") (re.++ (re.+ (re.diff re.allchar (str.to_re "\u{09}"))) (re.++ (str.to_re "\u{09}") (re.+ (re.diff re.allchar (str.to_re "\n"))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)