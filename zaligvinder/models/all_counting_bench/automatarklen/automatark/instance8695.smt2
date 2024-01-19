(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0][^0]|([^0]{1}(.){1})|[^0]*
(assert (not (str.in_re X (re.union (re.++ (str.to_re "0") (re.comp (str.to_re "0"))) (re.++ ((_ re.loop 1 1) (re.comp (str.to_re "0"))) ((_ re.loop 1 1) re.allchar)) (re.++ (re.* (re.comp (str.to_re "0"))) (str.to_re "\u{0a}"))))))
; 100013Agentsvr\x5E\x5EMerlinIPBeta\s\x3E\x3C
(assert (not (str.in_re X (re.++ (str.to_re "100013Agentsvr^^Merlin\u{13}IPBeta") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "><\u{0a}")))))
; AgentHWAEUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "AgentHWAEUser-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
