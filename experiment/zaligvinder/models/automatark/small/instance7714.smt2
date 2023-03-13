(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (.|[\r\n]){1,5}
(assert (str.in_re X (re.++ ((_ re.loop 1 5) (re.union re.allchar (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))))
; PortweatherX-Mailer\u{3a}User-Agent\x3AToolbar
(assert (not (str.in_re X (str.to_re "PortweatherX-Mailer:\u{13}User-Agent:Toolbar\u{0a}"))))
; HXDownloadUser-Agent\x3AanswerDeletingCookieReferer\x3A
(assert (not (str.in_re X (str.to_re "HXDownloadUser-Agent:answerDeletingCookieReferer:\u{0a}"))))
; (^(\d|,)*\.?\d*[1-9]+\d*$)|(^[1-9]+(\d|,)*\.\d*$)|(^[1-9]+(\d|,)*\d*$)
(assert (str.in_re X (re.union (re.++ (re.* (re.union (re.range "0" "9") (str.to_re ","))) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))) (re.++ (re.+ (re.range "1" "9")) (re.* (re.union (re.range "0" "9") (str.to_re ","))) (str.to_re ".") (re.* (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.+ (re.range "1" "9")) (re.* (re.union (re.range "0" "9") (str.to_re ","))) (re.* (re.range "0" "9"))))))
(check-sat)
