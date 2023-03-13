;test regex (\d{1,6}\040?(,|-)?\040?){1,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 1 6) (re.range "0" "9")) (re.++ (re.opt (str.to_re "\u{0020}")) (re.++ (re.opt (re.union (str.to_re ",") (str.to_re "-"))) (re.opt (str.to_re "\u{0020}")))))) ((_ re.loop 1 1) (re.++ ((_ re.loop 1 6) (re.range "0" "9")) (re.++ (re.opt (str.to_re "\u{0020}")) (re.++ (re.opt (re.union (str.to_re ",") (str.to_re "-"))) (re.opt (str.to_re "\u{0020}")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)