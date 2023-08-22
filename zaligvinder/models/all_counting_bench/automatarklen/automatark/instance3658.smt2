(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([^\s]){5,12}$
(assert (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; /^User\x2DAgent\x3A\s*Mozilla\u{0d}?$/smiH
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Mozilla") (re.opt (str.to_re "\u{0d}")) (str.to_re "/smiH\u{0a}")))))
; c\.goclick\.com\s+URLBlaze\s+Host\x3A
(assert (str.in_re X (re.++ (str.to_re "c.goclick.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlaze") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; updates\x5D\u{25}20\x5BPort_NETObserve
(assert (not (str.in_re X (str.to_re "updates]%20[Port_NETObserve\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
