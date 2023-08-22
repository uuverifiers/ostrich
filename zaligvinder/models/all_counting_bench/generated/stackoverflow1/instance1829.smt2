;test regex [0-9]{2}(([0-0]{1}[1-9]{1})|([1-1]{1}[0-2]{1}))(([0-0]{1}[1-9]{1})|([1-2]{1}[0-9]{1})|[3-3]{1}[0-1]{1})-[01|21|23|24|01]{2}-[0-9]{4}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "0")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "1")) ((_ re.loop 1 1) (re.range "0" "2")))) (re.++ (re.union (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "0")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "2")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.++ ((_ re.loop 1 1) (re.range "3" "3")) ((_ re.loop 1 1) (re.range "0" "1")))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.union (str.to_re "01") (re.union (str.to_re "|") (re.union (str.to_re "21") (re.union (str.to_re "|") (re.union (str.to_re "23") (re.union (str.to_re "|") (re.union (str.to_re "24") (re.union (str.to_re "|") (str.to_re "01")))))))))) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)