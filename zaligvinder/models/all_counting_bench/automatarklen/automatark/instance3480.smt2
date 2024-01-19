(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b(((\S+)?)(@|mailto\:|(news|(ht|f)tp(s?))\://)\S+)\b
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.union (str.to_re "@") (str.to_re "mailto:") (re.++ (re.union (str.to_re "news") (re.++ (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")))) (str.to_re "://"))) (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))))
; /\u{2e}otf([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.otf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^[+]447\d{9}$
(assert (str.in_re X (re.++ (str.to_re "+447") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
