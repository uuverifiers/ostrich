(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}OnlineUser-Agent\x3Awww\x2Evip-se\x2Ecom
(assert (str.in_re X (str.to_re "Host:OnlineUser-Agent:www.vip-se.com\u{13}\u{0a}")))
; DownloadDmInf\x5EinfoSimpsonUser-Agent\x3AClient
(assert (str.in_re X (str.to_re "DownloadDmInf^infoSimpsonUser-Agent:Client\u{0a}")))
; dialupvpn\u{5f}pwd\s+HXDownloadupdailyinformation
(assert (str.in_re X (re.++ (str.to_re "dialupvpn_pwd") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HXDownloadupdailyinformation\u{0a}"))))
; /^\/[a-f0-9]{8}\/[a-f0-9]{7,8}\/$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 7 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "//U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
