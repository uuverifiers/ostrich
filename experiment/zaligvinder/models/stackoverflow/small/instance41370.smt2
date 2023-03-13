;test regex (%{1}(\d+\$)?[-+\s0#]*(\d+|\*)?(\.\d+)?[bt]?[diuoxXfeEgGcs]+)+
(declare-const X String)
(assert (str.in_re X (re.+ (re.++ ((_ re.loop 1 1) (str.to_re "%")) (re.++ (re.opt (re.++ (re.+ (re.range "0" "9")) (str.to_re "$"))) (re.++ (re.* (re.union (str.to_re "-") (re.union (str.to_re "+") (re.union (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.union (str.to_re "0") (str.to_re "#")))))) (re.++ (re.opt (re.union (re.+ (re.range "0" "9")) (str.to_re "*"))) (re.++ (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (re.++ (re.opt (re.union (str.to_re "b") (str.to_re "t"))) (re.+ (re.union (str.to_re "d") (re.union (str.to_re "i") (re.union (str.to_re "u") (re.union (str.to_re "o") (re.union (str.to_re "x") (re.union (str.to_re "X") (re.union (str.to_re "f") (re.union (str.to_re "e") (re.union (str.to_re "E") (re.union (str.to_re "g") (re.union (str.to_re "G") (re.union (str.to_re "c") (str.to_re "s")))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)