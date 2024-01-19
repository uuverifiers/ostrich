(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\s+BossUser-Agent\x3ASpediaUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "BossUser-Agent:SpediaUser-Agent:\u{0a}")))))
; /\u{2e}pict([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.pict") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; st=\s+Stopper\s+Host\x3AAgentProjectMyWebSearchSearchAssistant
(assert (str.in_re X (re.++ (str.to_re "st=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Stopper") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:AgentProjectMyWebSearchSearchAssistant\u{0a}"))))
; ^[1-4]{1}[0-9]{4}(-)?[0-9]{7}(-)?[0-9]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "4")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
