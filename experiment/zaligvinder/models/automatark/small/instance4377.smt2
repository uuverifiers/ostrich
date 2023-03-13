(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\d+Subject\x3A[^\n\r]*Seconds\-ovplHost\x3AHost\x3ADownload
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Subject:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Seconds-ovplHost:Host:Download\u{0a}")))))
; SAccsearchresltOnline100013Agentsvr\x5E\x5EMerlin
(assert (str.in_re X (str.to_re "SAccsearchresltOnline100013Agentsvr^^Merlin\u{13}\u{0a}")))
; (^\([0]\d{1}\))(\d{7}$)|(^\([0][2]\d{1}\))(\d{6,8}$)|([0][8][0][0])([\s])(\d{5,8}$)
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "(0") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ")")) (re.++ ((_ re.loop 6 8) (re.range "0" "9")) (str.to_re "(02") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ")")) (re.++ (str.to_re "0800") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 5 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; to=.*JMail\d+HXDownloadasdbiz\x2EbizUser-Agent\x3Awww\x2Eezula\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "to=") (re.* re.allchar) (str.to_re "JMail") (re.+ (re.range "0" "9")) (str.to_re "HXDownloadasdbiz.bizUser-Agent:www.ezula.com\u{0a}")))))
(check-sat)
