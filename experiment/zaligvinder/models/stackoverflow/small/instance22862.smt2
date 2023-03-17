;test regex [?:0|24|0024]{1,3}[232|123|3434]{3,4}[0-9]{9}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 1 3) (re.union (str.to_re "?") (re.union (str.to_re ":") (re.union (str.to_re "0") (re.union (str.to_re "|") (re.union (str.to_re "24") (re.union (str.to_re "|") (str.to_re "0024")))))))) (re.++ ((_ re.loop 3 4) (re.union (str.to_re "232") (re.union (str.to_re "|") (re.union (str.to_re "123") (re.union (str.to_re "|") (str.to_re "3434")))))) ((_ re.loop 9 9) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)