(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Ephp\s+Host\x3Aorigin\x3Dsidefind\u{22}The
(assert (not (str.in_re X (re.++ (str.to_re ".php") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:origin=sidefind\u{22}The\u{0a}")))))
; /\u{2e}pfa([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pfa") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; <(.*?)>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* re.allchar) (str.to_re ">\u{0a}")))))
; /\u{2e}mim([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.mim") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^([0-1][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])([Z]|\.[0-9]{4}|[-|\+]([0-1][0-9]|2[0-3]):([0-5][0-9]))?$
(assert (str.in_re X (re.++ (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::") (re.opt (re.union (str.to_re "Z") (re.++ (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (str.to_re "-") (str.to_re "|") (str.to_re "+")) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9")))) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9"))))
(check-sat)
