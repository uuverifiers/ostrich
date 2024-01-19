;test regex .{31}.*[xX]\u{20}[pP]\u{20}_\u{20}[sS]\u{20}[pP]\u{20}[rR]\u{20}[iI]\u{20}[nN]\u{20}[tT]\u{20}[fF]\u{20}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 31 31) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re "x") (str.to_re "X")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "p") (str.to_re "P")) (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "_") (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "s") (str.to_re "S")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "p") (str.to_re "P")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "r") (str.to_re "R")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "i") (str.to_re "I")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "n") (str.to_re "N")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "t") (str.to_re "T")) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "f") (str.to_re "F")) (str.to_re "\u{20}"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)