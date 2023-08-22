(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Windows\x2Fclient\x2FBlackreportc\.goclick\.comX-Sender\x3A
(assert (not (str.in_re X (str.to_re "Windows/client/Blackreportc.goclick.comX-Sender:\u{13}\u{0a}"))))
; Port\s+AgentHost\x3Ainsertkeys\x3Ckeys\u{40}hotpop
(assert (str.in_re X (re.++ (str.to_re "Port") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AgentHost:insertkeys<keys@hotpop\u{0a}"))))
; (\"http:\/\/www\.youtube\.com\/v\/\w{11}\&rel\=1\")
(assert (str.in_re X (re.++ (str.to_re "\u{0a}\u{22}http://www.youtube.com/v/") ((_ re.loop 11 11) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "&rel=1\u{22}"))))
(assert (> (str.len X) 10))
(check-sat)
