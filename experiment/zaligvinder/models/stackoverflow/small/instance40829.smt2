;test regex ^(?:[\u0009-\u000D\u001C-\u007E\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDCF\uFDF0-\uFDFF\uFE70-\uFEFF]|(?:\uD802[\uDE60-\uDE9F]|\uD83B[\uDE00-\uDEFF])){0,30}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 0 30) (re.union (re.union (re.range "\u{0009}" "\u{000d}") (re.union (re.range "\u{001c}" "\u{007e}") (re.union (re.range "\u{0600}" "\u{06ff}") (re.union (re.range "\u{0750}" "\u{077f}") (re.union (re.range "\u{08a0}" "\u{08ff}") (re.union (re.range "\u{fb50}" "\u{fdcf}") (re.union (re.range "\u{fdf0}" "\u{fdff}") (re.range "\u{fe70}" "\u{feff}")))))))) (re.union (re.++ (str.to_re "\u{d802}") (re.range "\u{de60}" "\u{de9f}")) (re.++ (str.to_re "\u{d83b}") (re.range "\u{de00}" "\u{deff}")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)