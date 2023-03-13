(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\b)(\w+(\b|\n|\s)){3}
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}")))))
(check-sat)
