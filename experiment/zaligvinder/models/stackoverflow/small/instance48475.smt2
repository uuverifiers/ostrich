;test regex ([0-9]{6}[-*][0-9xX]{7}).*([0-9]{1,3}-[0-9]{1,3}-[0-9]{1,3}).*([FPTSUCD])=?([01][*-])
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (re.union (str.to_re "-") (str.to_re "*")) ((_ re.loop 7 7) (re.union (re.range "0" "9") (re.union (str.to_re "x") (str.to_re "X")))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 1 3) (re.range "0" "9")))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re "F") (re.union (str.to_re "P") (re.union (str.to_re "T") (re.union (str.to_re "S") (re.union (str.to_re "U") (re.union (str.to_re "C") (str.to_re "D"))))))) (re.++ (re.opt (str.to_re "=")) (re.++ (str.to_re "01") (re.union (str.to_re "*") (str.to_re "-")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)