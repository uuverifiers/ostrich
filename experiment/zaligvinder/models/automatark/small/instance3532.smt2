(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[01]?[- .]?\(?[2-9]\d{2}\)?[- .]?\d{3}[- .]?\d{4}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) (re.opt (str.to_re "(")) (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; mywayUser-Agent\x3AHost\x3ARedirector\u{22}body=FeaR\u{25}200\x2E2\x2E0\u{25}20Online\x3A\u{25}20\x5BIP_
(assert (not (str.in_re X (str.to_re "mywayUser-Agent:Host:Redirector\u{22}body=FeaR%200.2.0%20Online:%20[IP_\u{0a}"))))
; welcome\s+Host\x3A\s+ThistoIpHost\x3Abadurl\x2Egrandstreetinteractive\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "welcome") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ThistoIpHost:badurl.grandstreetinteractive.com\u{0a}")))))
; ^[1-9]\d?-\d{7}$
(assert (not (str.in_re X (re.++ (re.range "1" "9") (re.opt (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^User-Agent\x3A[^\r\n]*malware/miH
(assert (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "malware/miH\u{0a}"))))
(check-sat)
