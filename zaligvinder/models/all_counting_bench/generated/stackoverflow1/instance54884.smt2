;test regex ^([a-zA-Z0-9_-\u0600-\u065f\u066a-\u06EF\u06fa-\u06ff\ufb8a\u067e\u0686\u06af\u0750-\u077f\ufb50-\ufbc1\ufbd3-\ufd3f\ufd50-\ufd8f\ufd92-\ufdc7\ufe70-\ufefc\uFDF0-\uFDFD]+){3,5}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 3 5) (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (re.range "_" "\u{0600}") (re.union (str.to_re "-") (re.union (str.to_re "\u{065f}") (re.union (re.range "\u{066a}" "\u{06ef}") (re.union (re.range "\u{06fa}" "\u{06ff}") (re.union (str.to_re "\u{fb8a}") (re.union (str.to_re "\u{067e}") (re.union (str.to_re "\u{0686}") (re.union (str.to_re "\u{06af}") (re.union (re.range "\u{0750}" "\u{077f}") (re.union (re.range "\u{fb50}" "\u{fbc1}") (re.union (re.range "\u{fbd3}" "\u{fd3f}") (re.union (re.range "\u{fd50}" "\u{fd8f}") (re.union (re.range "\u{fd92}" "\u{fdc7}") (re.union (re.range "\u{fe70}" "\u{fefc}") (re.range "\u{fdf0}" "\u{fdfd}")))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)