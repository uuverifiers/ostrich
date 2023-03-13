(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; are\s+Toolbar\s+X-Mailer\x3AInformationsearchnuggetspastb\x2Efreeprod\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "are") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}Informationsearchnugget\u{13}spastb.freeprod.com\u{0a}")))))
; Uin=encodernotification\x2Ftoolbar\x2FHost\x3AUser-Agent\x3A
(assert (str.in_re X (str.to_re "Uin=encodernotification\u{13}/toolbar/Host:User-Agent:\u{0a}")))
; /^\/\w{1,2}\/\w{1,3}\.class$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".class/U\u{0a}"))))
; for.*www\x2Eeblocs\x2Ecom\d\x2Fiis2ebs\.asp\d\<title\>Actual\x2Fpagead\x2Fads\?search2\.ad\.shopnav\.com\x2F9899\x2Fsearch\x2Fresults\.php
(assert (str.in_re X (re.++ (str.to_re "for") (re.* re.allchar) (str.to_re "www.eblocs.com\u{1b}") (re.range "0" "9") (str.to_re "/iis2ebs.asp") (re.range "0" "9") (str.to_re "<title>Actual/pagead/ads?search2.ad.shopnav.com/9899/search/results.php\u{0a}"))))
; ([1,2].)(\d{2}.)(\d{2}.)(\d{2}.)(\d{3}.)(\d{3}.)(\d{2})
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}") (re.union (str.to_re "1") (str.to_re ",") (str.to_re "2")) re.allchar ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar)))
(check-sat)
