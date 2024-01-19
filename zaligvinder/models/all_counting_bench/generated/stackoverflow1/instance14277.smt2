;test regex this.ssnRegex='^(\d{6}|\d{8})[-|(\s)]{0,1}\d{4}$';
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (re.++ (str.to_re "s") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "s") (re.++ (str.to_re "s") (re.++ (str.to_re "n") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "=") (str.to_re "\u{27}"))))))))))))))) (re.++ (str.to_re "") (re.++ (re.union ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ ((_ re.loop 0 1) (re.union (str.to_re "-") (re.union (str.to_re "|") (re.union (str.to_re "(") (re.union (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (str.to_re ")")))))) ((_ re.loop 4 4) (re.range "0" "9")))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{27}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)