(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([4]{1})([0-9]{12,15})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "4")) ((_ re.loop 12 15) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; <a\s*href=(.*?)[\s|>]
(assert (not (str.in_re X (re.++ (str.to_re "<a") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "href=") (re.* re.allchar) (re.union (str.to_re "|") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}")))))
; /\u{2e}abc([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.abc") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(check-sat)
