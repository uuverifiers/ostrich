;test regex "([a-z0-9]+)_([0-9]+)_([v|V][0-9]+)_(\\d{4})(\\d{2})(\\d{2}).(xls|xlsx)".r
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "_") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (re.++ (re.union (str.to_re "v") (re.union (str.to_re "|") (str.to_re "V"))) (re.+ (re.range "0" "9"))) (re.++ (str.to_re "_") (re.++ (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d"))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.union (re.++ (str.to_re "x") (re.++ (str.to_re "l") (str.to_re "s"))) (re.++ (str.to_re "x") (re.++ (str.to_re "l") (re.++ (str.to_re "s") (str.to_re "x"))))) (re.++ (str.to_re "\u{22}") (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re "r")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)