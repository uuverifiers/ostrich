(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Epurityscan\x2Ecom.*
(assert (not (str.in_re X (re.++ (str.to_re "www.purityscan.com") (re.* re.allchar) (str.to_re "\u{0a}")))))
; ^\d{1,5}(\.\d{1,2})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3AHost\x3ALOGServer\.compressxpsp2-toolbar\x2Ehotblox\x2EcomAttached100013Agentsvr\x5E\x5EMerlin
(assert (str.in_re X (str.to_re "Host:Host:LOGServer.compressxpsp2-toolbar.hotblox.comAttached100013Agentsvr^^Merlin\u{13}\u{0a}")))
; Contact\d+Host\x3A[^\n\r]*User-Agent\x3AHost\u{3a}MailHost\u{3a}MSNLOGOVN
(assert (str.in_re X (re.++ (str.to_re "Contact") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:Host:MailHost:MSNLOGOVN\u{0a}"))))
; / \x2D .{1,20}\u{07}(LAN|PROXY|MODEM|MODEM BUSY|UNKNOWN)\u{07}Win/
(assert (not (str.in_re X (re.++ (str.to_re "/ - ") ((_ re.loop 1 20) re.allchar) (str.to_re "\u{07}") (re.union (str.to_re "LAN") (str.to_re "PROXY") (str.to_re "MODEM") (str.to_re "MODEM BUSY") (str.to_re "UNKNOWN")) (str.to_re "\u{07}Win/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
