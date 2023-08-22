;test regex ^(\d{6})(\d{4})?(C|D|RC|RD)\D?(\d{1,12},\d{0,2})((?:N|F).{3})(NONREF|.{0,16})(?:$|\/\/)(.*)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (re.opt ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (re.union (re.union (str.to_re "C") (str.to_re "D")) (re.++ (str.to_re "R") (str.to_re "C"))) (re.++ (str.to_re "R") (str.to_re "D"))) (re.++ (re.opt (re.diff re.allchar (re.range "0" "9"))) (re.++ (re.++ ((_ re.loop 1 12) (re.range "0" "9")) (re.++ (str.to_re ",") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (re.++ (re.union (str.to_re "N") (str.to_re "F")) ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.union (re.++ (str.to_re "N") (re.++ (str.to_re "O") (re.++ (str.to_re "N") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (str.to_re "F")))))) ((_ re.loop 0 16) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.union (str.to_re "") (re.++ (str.to_re "/") (str.to_re "/"))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)