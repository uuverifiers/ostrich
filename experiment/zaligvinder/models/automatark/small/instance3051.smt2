(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{0,5}[ ]{0,1}[0-9]{0,6}$
(assert (str.in_re X (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 0 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Uin=\s+\.htaServerTheef2trustyfiles\x2EcomlogsHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Uin=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".htaServerTheef2trustyfiles.comlogsHost:\u{0a}")))))
; Host\x3AAddressDaemonUser-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (str.to_re "Host:AddressDaemonUser-Agent:User-Agent:\u{0a}"))))
(check-sat)
