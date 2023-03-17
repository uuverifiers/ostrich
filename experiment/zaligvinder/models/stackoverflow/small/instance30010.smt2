;test regex [^A-Za-z]{0,}c[\,\.\;\s]{0,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.diff re.allchar (re.range "a" "z")))) ((_ re.loop 0 0) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.diff re.allchar (re.range "a" "z"))))) (re.++ (str.to_re "c") (re.++ (re.* (re.union (str.to_re ",") (re.union (str.to_re ".") (re.union (str.to_re ";") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))) ((_ re.loop 0 0) (re.union (str.to_re ",") (re.union (str.to_re ".") (re.union (str.to_re ";") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)