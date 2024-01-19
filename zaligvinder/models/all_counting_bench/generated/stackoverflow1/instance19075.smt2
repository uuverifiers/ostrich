;test regex ^H{1}[ome!@#\$%\^&\*\(\)_\+\-=\[\]\{\}\;':"\\\|,\.<>\/?]+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (str.to_re "H")) (re.+ (re.union (str.to_re "o") (re.union (str.to_re "m") (re.union (str.to_re "e") (re.union (str.to_re "!") (re.union (str.to_re "@") (re.union (str.to_re "#") (re.union (str.to_re "$") (re.union (str.to_re "%") (re.union (str.to_re "^") (re.union (str.to_re "&") (re.union (str.to_re "*") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "_") (re.union (str.to_re "+") (re.union (str.to_re "-") (re.union (str.to_re "=") (re.union (str.to_re "[") (re.union (str.to_re "]") (re.union (str.to_re "{") (re.union (str.to_re "}") (re.union (str.to_re ";") (re.union (str.to_re "\u{27}") (re.union (str.to_re ":") (re.union (str.to_re "\u{22}") (re.union (str.to_re "\\") (re.union (str.to_re "|") (re.union (str.to_re ",") (re.union (str.to_re ".") (re.union (str.to_re "<") (re.union (str.to_re ">") (re.union (str.to_re "/") (str.to_re "?")))))))))))))))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)