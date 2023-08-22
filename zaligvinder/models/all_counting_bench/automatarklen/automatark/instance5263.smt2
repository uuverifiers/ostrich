(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SAccsearchresltOnline100013Agentsvr\x5E\x5EMerlin
(assert (not (str.in_re X (str.to_re "SAccsearchresltOnline100013Agentsvr^^Merlin\u{13}\u{0a}"))))
; ^(\s*\d\s*){11}$
(assert (str.in_re X (re.++ ((_ re.loop 11 11) (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "\u{0a}"))))
; \x3BCIA\s+is\s+User-Agent\x3Acid=tb\u{2e}Cookie\x3A
(assert (str.in_re X (re.++ (str.to_re ";CIA") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:cid=tb.Cookie:\u{0a}"))))
; tv\x2E180solutions\x2EcomGirlFriendHost\x3A
(assert (str.in_re X (str.to_re "tv.180solutions.comGirlFriendHost:\u{0a}")))
; (^[0-9]{0,10}$)
(assert (not (str.in_re X (re.++ ((_ re.loop 0 10) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
