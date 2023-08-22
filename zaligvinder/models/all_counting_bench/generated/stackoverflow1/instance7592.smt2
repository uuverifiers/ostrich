;test regex (?:([\[\]\{\}\":]+)|(ip")|(port")|\s{2,})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.+ (re.union (str.to_re "[") (re.union (str.to_re "]") (re.union (str.to_re "{") (re.union (str.to_re "}") (re.union (str.to_re "\u{22}") (str.to_re ":"))))))) (re.++ (str.to_re "i") (re.++ (str.to_re "p") (str.to_re "\u{22}")))) (re.++ (str.to_re "p") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "t") (str.to_re "\u{22}")))))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) ((_ re.loop 2 2) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)