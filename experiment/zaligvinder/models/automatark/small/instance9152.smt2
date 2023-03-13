(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}\d{3}\u{2f}\d{3}\u{2e}html$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".html/U\u{0a}"))))
; \x2Frss\d+answer\sHost\x3A
(assert (str.in_re X (re.++ (str.to_re "/rss") (re.+ (re.range "0" "9")) (str.to_re "answer") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}"))))
(check-sat)
