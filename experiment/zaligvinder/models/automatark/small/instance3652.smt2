(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.opt (re.union (re.++ (str.to_re "2") (re.range "0" "4")) (re.++ (re.opt (str.to_re "1")) (re.range "0" "9")))) (re.range "0" "9"))) (str.to_re "."))) (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.opt (re.union (re.++ (str.to_re "2") (re.range "0" "4")) (re.++ (re.opt (str.to_re "1")) (re.range "0" "9")))) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; (\[url=?"?)([^\]"]*)("?\])([^\[]*)(\[/url\])
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "]") (str.to_re "\u{22}"))) (re.* (re.comp (str.to_re "["))) (str.to_re "[/url]\u{0a}[url") (re.opt (str.to_re "=")) (re.opt (str.to_re "\u{22}")) (re.opt (str.to_re "\u{22}")) (str.to_re "]")))))
; ^[1-9]{1}[0-9]{3}\s?[a-zA-Z]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; Keylogger\w+Owner\x3A\dBetaWordixqshv\u{2f}qzccsServer\u{00}MyBYReferer\x3Awww\x2Eccnnlc\x2Ecom\u{04}\u{00}
(assert (str.in_re X (re.++ (str.to_re "Keylogger") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:") (re.range "0" "9") (str.to_re "BetaWordixqshv/qzccsServer\u{00}MyBYReferer:www.ccnnlc.com\u{13}\u{04}\u{00}\u{0a}"))))
(check-sat)
