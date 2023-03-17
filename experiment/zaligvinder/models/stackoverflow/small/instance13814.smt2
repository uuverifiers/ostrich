;test regex (?:(?:\x1B\[[\d;]*m)*[^\x1B]){1,3}(?:(?:\x1B\[[\d;]*m)+$)?
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.++ (re.* (re.++ (str.to_re "\u{1b}") (re.++ (str.to_re "[") (re.++ (re.* (re.union (re.range "0" "9") (str.to_re ";"))) (str.to_re "m"))))) (re.diff re.allchar (str.to_re "\u{1b}")))) (re.opt (re.++ (re.+ (re.++ (str.to_re "\u{1b}") (re.++ (str.to_re "[") (re.++ (re.* (re.union (re.range "0" "9") (str.to_re ";"))) (str.to_re "m"))))) (str.to_re ""))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)