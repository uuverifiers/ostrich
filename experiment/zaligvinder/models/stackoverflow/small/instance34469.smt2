;test regex ^[\u0000-\u007F\u0080-\u00FF\u0100-\u017F\u0180-024F\u1E00-\u1EFF'0-9-]{2}.*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.union (re.range "\u{0000}" "\u{007f}") (re.union (re.range "\u{0080}" "\u{00ff}") (re.union (re.range "\u{0100}" "\u{017f}") (re.union (re.range "\u{0180}" "024") (re.union (str.to_re "F") (re.union (re.range "\u{1e00}" "\u{1eff}") (re.union (str.to_re "\u{27}") (re.union (re.range "0" "9") (str.to_re "-")))))))))) (re.* (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)