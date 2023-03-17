;test regex http[s]?://.+/(?:[V|v]\d+|[V|v]\d+\.\d+)/([a-z|A-Z|0-9]{32})(?:/|$)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "/") (re.++ (re.union (re.++ (re.union (str.to_re "V") (re.union (str.to_re "|") (str.to_re "v"))) (re.+ (re.range "0" "9"))) (re.++ (re.union (str.to_re "V") (re.union (str.to_re "|") (str.to_re "v"))) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.union (str.to_re "|") (re.union (re.range "A" "Z") (re.union (str.to_re "|") (re.range "0" "9")))))) (re.union (str.to_re "/") (str.to_re "")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)