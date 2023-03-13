(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 195\.225\.\<title\>Actual
(assert (not (str.in_re X (str.to_re "195.225.<title>Actual\u{0a}"))))
; search2\.ad\.shopnav\.com\x2F9899\x2Fsearch\x2Fresults\.php.*Logger.*Subject\u{3a}\s+Host\x3AHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "search2.ad.shopnav.com/9899/search/results.php") (re.* re.allchar) (str.to_re "Logger") (re.* re.allchar) (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:\u{0a}")))))
; ^((\d{1,3}((,\d{3})*|\d*)(\.{0,1})\d+)|\d+)$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.* (re.range "0" "9"))) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; WebsiteUser-Agent\x3Ahttphostfast-look\x2Ecom
(assert (str.in_re X (str.to_re "WebsiteUser-Agent:httphostfast-look.com\u{0a}")))
(check-sat)
