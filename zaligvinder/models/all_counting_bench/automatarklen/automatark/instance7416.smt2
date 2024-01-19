(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\?new\=.*?\:.*?\&v\=\d\.\d\.\d\&av\=/U
(assert (not (str.in_re X (re.++ (str.to_re "/?new=") (re.* re.allchar) (str.to_re ":") (re.* re.allchar) (str.to_re "&v=") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re "&av=/U\u{0a}")))))
; www\x2Esogou\x2Ecomix=WebsiteHost\u{3a}Web-Mail
(assert (str.in_re X (str.to_re "www.sogou.comix=WebsiteHost:Web-Mail\u{0a}")))
; Host\u{3a}OnlineUser-Agent\x3Awww\x2Evip-se\x2Ecom
(assert (not (str.in_re X (str.to_re "Host:OnlineUser-Agent:www.vip-se.com\u{13}\u{0a}"))))
; ^[A-Za-z]{1,2}[0-9A-Za-z]{1,2}[ ]?[0-9]{0,1}[A-Za-z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re " ")) (re.opt (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; /\r\nReferer\x3A\u{20}http\x3A\x2F\u{2f}[a-z0-9\u{2d}\u{2e}]+\x2F\x3Fdo\x3Dpayment\u{26}ver\x3D\d+\u{26}sid\x3D\d+\u{26}sn\x3D\d+\r\n/H
(assert (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}Referer: http://") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re "/?do=payment&ver=") (re.+ (re.range "0" "9")) (str.to_re "&sid=") (re.+ (re.range "0" "9")) (str.to_re "&sn=") (re.+ (re.range "0" "9")) (str.to_re "\u{0d}\u{0a}/H\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
