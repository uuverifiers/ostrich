;test regex [a-z0-9\u{20}\u{21}\x2E\x3A\x3B\x3F\x2C\u{27}\u{22}]{0,600}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 0 600) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{21}") (re.union (str.to_re "\u{2e}") (re.union (str.to_re "\u{3a}") (re.union (str.to_re "\u{3b}") (re.union (str.to_re "\u{3f}") (re.union (str.to_re "\u{2c}") (re.union (str.to_re "\u{27}") (str.to_re "\u{22}"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)