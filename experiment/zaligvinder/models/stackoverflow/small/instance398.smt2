;test regex "$10+".matches("^\\\\${0,1}[1-9,\\\\.]{0,}[\\\\+kK]{0,}")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.+ (str.to_re "10")) (re.++ (str.to_re "\u{22}") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (str.to_re "\\") (str.to_re "\\")))) (re.++ ((_ re.loop 0 1) (str.to_re "")) (re.++ (re.++ (re.* (re.union (re.range "1" "9") (re.union (str.to_re ",") (re.union (str.to_re "\\") (re.union (str.to_re "\\") (str.to_re ".")))))) ((_ re.loop 0 0) (re.union (re.range "1" "9") (re.union (str.to_re ",") (re.union (str.to_re "\\") (re.union (str.to_re "\\") (str.to_re "."))))))) (re.++ (re.++ (re.* (re.union (str.to_re "\\") (re.union (str.to_re "\\") (re.union (str.to_re "+") (re.union (str.to_re "k") (str.to_re "K")))))) ((_ re.loop 0 0) (re.union (str.to_re "\\") (re.union (str.to_re "\\") (re.union (str.to_re "+") (re.union (str.to_re "k") (str.to_re "K"))))))) (str.to_re "\u{22}")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)