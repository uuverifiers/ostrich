(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \\s\\d{2}[-]\\w{3}-\\d{4}
(assert (str.in_re X (re.++ (str.to_re "\u{5c}s\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 3 3) (str.to_re "w")) (str.to_re "-\u{5c}") ((_ re.loop 4 4) (str.to_re "d")) (str.to_re "\u{0a}"))))
; 3ASoftwarephpinfoSpy\x2EnbdMailerX-Mailer\x3A195\.225\.Subject\u{3a}
(assert (not (str.in_re X (str.to_re "3ASoftwarephpinfoSpy.nbdMailerX-Mailer:\u{13}195.225.Subject:\u{0a}"))))
; SpywareinformationToolBarX-Mailer\u{3a}User-Agent\x3AMM_RECO\x2EEXE
(assert (not (str.in_re X (str.to_re "SpywareinformationToolBarX-Mailer:\u{13}User-Agent:MM_RECO.EXE\u{0a}"))))
; ^((19[0-9][0-9])|(20[0-1][0-5]))\-((0?[1-9])|(1[0-2]))\-((0?[1-9])|([1-2][0-9])|(3[0-1]))$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "20") (re.range "0" "1") (re.range "0" "5"))) (str.to_re "-") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "-") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "\u{0a}"))))
; Host\x3AUser-Agent\u{3a}Host\x3APortScaner
(assert (not (str.in_re X (str.to_re "Host:User-Agent:Host:PortScaner\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
