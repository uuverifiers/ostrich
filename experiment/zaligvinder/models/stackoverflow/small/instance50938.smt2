;test regex ([\$\xA2-\xA5\u058F\u060B\u09F2\u09F3\u09FB\u0AF1\u0BF9\u0E3F\u17DB\u20A0-\u20BD\uA838\uFDFC\uFE69\uFF04\uFFE0\uFFE1\uFFE5\uFFE6]\d+\.\d{2})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "$") (re.union (re.range "\u{a2}" "\u{a5}") (re.union (str.to_re "\u{058f}") (re.union (str.to_re "\u{060b}") (re.union (str.to_re "\u{09f2}") (re.union (str.to_re "\u{09f3}") (re.union (str.to_re "\u{09fb}") (re.union (str.to_re "\u{0af1}") (re.union (str.to_re "\u{0bf9}") (re.union (str.to_re "\u{0e3f}") (re.union (str.to_re "\u{17db}") (re.union (re.range "\u{20a0}" "\u{20bd}") (re.union (str.to_re "\u{a838}") (re.union (str.to_re "\u{fdfc}") (re.union (str.to_re "\u{fe69}") (re.union (str.to_re "\u{ff04}") (re.union (str.to_re "\u{ffe0}") (re.union (str.to_re "\u{ffe1}") (re.union (str.to_re "\u{ffe5}") (str.to_re "\u{ffe6}")))))))))))))))))))) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)