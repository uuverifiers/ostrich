(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([0-9]{1,2}[:][0-9]{1,2}[:]{0,2}[0-9]{0,2}[\s]{0,}[AMPamp]{0,2})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 0 2) (str.to_re ":")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 2) (re.union (str.to_re "A") (str.to_re "M") (str.to_re "P") (str.to_re "a") (str.to_re "m") (str.to_re "p"))))))
; Port\s+AgentHost\x3Ainsertkeys\x3Ckeys\u{40}hotpop
(assert (not (str.in_re X (re.++ (str.to_re "Port") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AgentHost:insertkeys<keys@hotpop\u{0a}")))))
; /\u{2e}3gp([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.3gp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; \u{1f}\u{8b}\u{08}\u{00}.+\u{00}\u{00}
(assert (str.in_re X (re.++ (str.to_re "\u{1f}\u{8b}\u{08}\u{00}") (re.+ re.allchar) (str.to_re "\u{00}\u{00}\u{0a}"))))
(check-sat)
