;test regex (^|[^a-z0-9_])[@]([a-z0-9_]{1,20})([@\xC0-\xD6\xD8-\xF6\xF8-\xFF]?)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "") (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_"))))) (re.++ (str.to_re "@") (re.++ ((_ re.loop 1 20) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.opt (re.union (str.to_re "@") (re.union (re.range "\u{c0}" "\u{d6}") (re.union (re.range "\u{d8}" "\u{f6}") (re.range "\u{f8}" "\u{ff}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)