(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(1)?(-|.)?(\()?([0-9]{3})(\))?(-|.)?([0-9]{3})(-|.)?([0-9]{4})/
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re "-") re.allchar)) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") re.allchar)) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") re.allchar)) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/\u{0a}"))))
; jsp\d+Host\x3A\d+moreKontikiHost\u{3a}AcmeEvilFTP
(assert (str.in_re X (re.++ (str.to_re "jsp") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "moreKontikiHost:AcmeEvilFTP\u{0a}"))))
; Admin\s+daosearch\x2EcomMyPostwww\.raxsearch\.comref\x3D\u{25}user\x5Fid
(assert (str.in_re X (re.++ (str.to_re "Admin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "daosearch.comMyPostwww.raxsearch.comref=%user_id\u{0a}"))))
; /\/3\/[A-Z]{2}\/[a-f0-9]{32}\/\d+\.\d+\.\d+\.\d+\//
(assert (not (str.in_re X (re.++ (str.to_re "//3/") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re "//\u{0a}")))))
; CodeguruBrowserMyPostStableWeb-MailUser-Agent\x3A195\.225\.
(assert (str.in_re X (str.to_re "CodeguruBrowserMyPostStableWeb-MailUser-Agent:195.225.\u{0a}")))
(check-sat)
