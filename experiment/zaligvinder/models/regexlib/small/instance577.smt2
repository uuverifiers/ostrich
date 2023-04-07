;test regex urn:[a-z0-9]{1}[a-z0-9\-]{1,31}:[a-z0-9_,:=@;!&#39;%/#\(\)\+\-\.\$\*\?]+
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re ":") (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ ((_ re.loop 1 31) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ (str.to_re ":") (re.+ (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (re.union (str.to_re ",") (re.union (str.to_re ":") (re.union (str.to_re "=") (re.union (str.to_re "@") (re.union (str.to_re ";") (re.union (str.to_re "!") (re.union (str.to_re "&") (re.union (str.to_re "#") (re.union (str.to_re "39") (re.union (str.to_re ";") (re.union (str.to_re "%") (re.union (str.to_re "/") (re.union (str.to_re "#") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "+") (re.union (str.to_re "-") (re.union (str.to_re ".") (re.union (str.to_re "$") (re.union (str.to_re "*") (str.to_re "?"))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)