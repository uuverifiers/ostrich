(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SI\|Server\|\s+OSSProxy\x5Chome\/lordofsearch%3fAuthorization\u{3a}
(assert (str.in_re X (re.++ (str.to_re "SI|Server|\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "OSSProxy\u{5c}home/lordofsearch%3fAuthorization:\u{0a}"))))
; www\s+X-Mailer\u{3a}SpyBuddyUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "www") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}SpyBuddyUser-Agent:\u{0a}"))))
; /\/SUS\d+O\d+\.jsp\?[a-z0-9=\u{2b}\u{2f}]{20}/iU
(assert (str.in_re X (re.++ (str.to_re "//SUS") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iU\u{0a}"))))
; /\.addAnnot\s*\u{28}[^\u{29}]*?points\s*\u{3a}\s*0/i
(assert (not (str.in_re X (re.++ (str.to_re "/.addAnnot") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ")"))) (str.to_re "points") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ":") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "0/i\u{0a}")))))
; /\u{b6}\u{b6}\u{ff}\u{ff}\u{ff}\u{ff}$/
(assert (not (str.in_re X (str.to_re "/\u{b6}\u{b6}\u{ff}\u{ff}\u{ff}\u{ff}/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
