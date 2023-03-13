;test regex [\u0024\u20AC\u00A5A-Z\s]{0,4}[0-9.,]+[\s\u0024\u20AC\u00A5A-Z]{0,4}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 4) (re.union (str.to_re "\u{0024}") (re.union (str.to_re "\u{20ac}") (re.union (re.range "\u{00a5a}" "Z") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))) (re.++ (re.+ (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re ",")))) ((_ re.loop 0 4) (re.union (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.union (str.to_re "\u{0024}") (re.union (str.to_re "\u{20ac}") (re.range "\u{00a5a}" "Z")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)