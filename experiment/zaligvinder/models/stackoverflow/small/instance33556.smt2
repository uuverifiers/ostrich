;test regex "^([1-9]\\d{0,2}(,\\d{3})*|([1-9]\\d*))(\\.\\d{2})?$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.range "1" "9") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 0 2) (str.to_re "d")) (re.* (re.++ (str.to_re ",") (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d")))))))) (re.++ (re.range "1" "9") (re.++ (str.to_re "\\") (re.* (str.to_re "d"))))) (re.opt (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)