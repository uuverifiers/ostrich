(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\S{2}\d{7}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
