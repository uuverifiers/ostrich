;test regex apple\([0-9]+,(?:[0-9]{1,2}|100)\);
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "a") (re.++ (str.to_re "p") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "(") (re.+ (re.range "0" "9")))))))) (re.++ (str.to_re ",") (re.++ (re.union ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "100")) (re.++ (str.to_re ")") (str.to_re ";")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)