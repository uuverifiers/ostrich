(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; .*(\.[Jj][Pp][Gg]|\.[Gg][Ii][Ff]|\.[Jj][Pp][Ee][Gg]|\.[Pp][Nn][Gg])
(assert (not (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}.") (re.union (re.++ (re.union (str.to_re "J") (str.to_re "j")) (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "G") (str.to_re "g"))) (re.++ (re.union (str.to_re "G") (str.to_re "g")) (re.union (str.to_re "I") (str.to_re "i")) (re.union (str.to_re "F") (str.to_re "f"))) (re.++ (re.union (str.to_re "J") (str.to_re "j")) (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "E") (str.to_re "e")) (re.union (str.to_re "G") (str.to_re "g"))) (re.++ (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "N") (str.to_re "n")) (re.union (str.to_re "G") (str.to_re "g"))))))))
; \.cfg\x2Fsearchfast\x2F\u{22}007A-SpyWebsitehttp\x3A\x2F\x2Fsupremetoolbar\.com\x2Findex\.php\?tpid=
(assert (not (str.in_re X (str.to_re ".cfg/searchfast/\u{22}007A-SpyWebsitehttp://supremetoolbar.com/index.php?tpid=\u{0a}"))))
; ^((\d{1,3}(,\d{3})*)|(\d{1,3}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; url=\d+Host\x3A.*backtrust\x2Ecomv\x2ELoginHost\u{3a}\x2Ffriendship\x2Femail_thank_you\?
(assert (not (str.in_re X (re.++ (str.to_re "url=") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.* re.allchar) (str.to_re "backtrust.comv.LoginHost:/friendship/email_thank_you?\u{0a}")))))
(check-sat)
