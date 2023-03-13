(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}OnlineUser-Agent\x3Awww\x2Evip-se\x2Ecom
(assert (str.in_re X (str.to_re "Host:OnlineUser-Agent:www.vip-se.com\u{13}\u{0a}")))
; url=\d+Host\x3A.*backtrust\x2Ecomv\x2ELoginHost\u{3a}\x2Ffriendship\x2Femail_thank_you\?
(assert (not (str.in_re X (re.++ (str.to_re "url=") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.* re.allchar) (str.to_re "backtrust.comv.LoginHost:/friendship/email_thank_you?\u{0a}")))))
; ^(\d{1,2})(\s?(H|h)?)(:([0-5]\d))?$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "H") (str.to_re "h"))))))
; Host\x3A\w+page=largePass-Onseqepagqfphv\u{2f}sfd
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "page=largePass-Onseqepagqfphv/sfd\u{0a}"))))
(check-sat)
