(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ('{2})*([^'\r\n]*)('{2})*([^'\r\n]*)('{2})*
(assert (not (str.in_re X (re.++ (re.* ((_ re.loop 2 2) (str.to_re "'"))) (re.* (re.union (str.to_re "'") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.* ((_ re.loop 2 2) (str.to_re "'"))) (re.* (re.union (str.to_re "'") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.* ((_ re.loop 2 2) (str.to_re "'"))) (str.to_re "\u{0a}")))))
; Host\x3AHost\x3ALOGServer\.compressxpsp2-toolbar\x2Ehotblox\x2EcomAttached100013Agentsvr\x5E\x5EMerlin
(assert (not (str.in_re X (str.to_re "Host:Host:LOGServer.compressxpsp2-toolbar.hotblox.comAttached100013Agentsvr^^Merlin\u{13}\u{0a}"))))
; ^[-]?\d{1,10}\.?([0-9][0-9])?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 10) (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.++ (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
