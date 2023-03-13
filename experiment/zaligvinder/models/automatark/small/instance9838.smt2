(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Keylogger\w+Owner\x3A\dBetaWordixqshv\u{2f}qzccsServer\u{00}MyBYReferer\x3Awww\x2Eccnnlc\x2Ecom\u{04}\u{00}
(assert (not (str.in_re X (re.++ (str.to_re "Keylogger") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:") (re.range "0" "9") (str.to_re "BetaWordixqshv/qzccsServer\u{00}MyBYReferer:www.ccnnlc.com\u{13}\u{04}\u{00}\u{0a}")))))
; FreeAccessBar\s+hostie[^\n\r]*CodeguruBrowser\dStableWeb-MailUser-Agent\x3A195\.225\.Subject\x3A
(assert (str.in_re X (re.++ (str.to_re "FreeAccessBar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hostie") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "CodeguruBrowser") (re.range "0" "9") (str.to_re "StableWeb-MailUser-Agent:195.225.Subject:\u{0a}"))))
; ((^([\d]{1,3})(,{1}([\d]{3}))*)|(^[\d]*))((\.{1}[\d]{2})?$)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ ((_ re.loop 1 1) (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.* (re.range "0" "9"))) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)
