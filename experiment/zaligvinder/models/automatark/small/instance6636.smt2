(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{2}([0][1-9]|[1][0-2])([0][1-9]|[1-2][0-9]|[3][0-1])-\d{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; LoggerovplUser-Agent\x3At=searchreslt\x7D\x7BSysuptime\x3A
(assert (not (str.in_re X (str.to_re "LoggerovplUser-Agent:t=searchreslt}{Sysuptime:\u{0a}"))))
; IP\s+\.hta.*Theef2trustyfiles\x2Ecomlogs
(assert (not (str.in_re X (re.++ (str.to_re "IP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".hta") (re.* re.allchar) (str.to_re "Theef2trustyfiles.comlogs\u{0a}")))))
; Host\x3AHost\x3ALOGServer\.compressxpsp2-toolbar\x2Ehotblox\x2EcomAttached100013Agentsvr\x5E\x5EMerlin
(assert (str.in_re X (str.to_re "Host:Host:LOGServer.compressxpsp2-toolbar.hotblox.comAttached100013Agentsvr^^Merlin\u{13}\u{0a}")))
(check-sat)
