;test regex ^[\t ]*(?:(?:-?[\d.]+[\t ]*){0,4}|(?:-?[\d.]+[\t ]+){5}[-\d.].*)$(?:\r?\n|\r)?
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.union (str.to_re "\u{09}") (str.to_re " "))) (re.union ((_ re.loop 0 4) (re.++ (re.opt (str.to_re "-")) (re.++ (re.+ (re.union (re.range "0" "9") (str.to_re "."))) (re.* (re.union (str.to_re "\u{09}") (str.to_re " ")))))) (re.++ ((_ re.loop 5 5) (re.++ (re.opt (str.to_re "-")) (re.++ (re.+ (re.union (re.range "0" "9") (str.to_re "."))) (re.+ (re.union (str.to_re "\u{09}") (str.to_re " ")))))) (re.++ (re.union (str.to_re "-") (re.union (re.range "0" "9") (str.to_re "."))) (re.* (re.diff re.allchar (str.to_re "\n")))))))) (re.++ (str.to_re "") (re.opt (re.union (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}")) (str.to_re "\u{0d}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)