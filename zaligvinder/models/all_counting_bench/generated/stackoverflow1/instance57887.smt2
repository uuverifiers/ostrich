;test regex ^((\s*tel[12]:\s*)?\+(E\d{4}49|\d)[^,]*(,|$))+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.+ (re.++ (re.opt (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "12") (re.++ (str.to_re ":") (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))))) (re.++ (str.to_re "+") (re.++ (re.union (re.++ (str.to_re "E") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "49"))) (re.range "0" "9")) (re.++ (re.* (re.diff re.allchar (str.to_re ","))) (re.union (str.to_re ",") (str.to_re "")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)