(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([EV])?\d{3,3}(\.\d{1,2})?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "E") (str.to_re "V"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; Keylogger-Protoolbarplace\x2Ecom
(assert (not (str.in_re X (str.to_re "Keylogger-Protoolbarplace.com\u{0a}"))))
; Host\x3A\d+UI2.*areprotocolhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "UI2") (re.* re.allchar) (str.to_re "areprotocolhttp://www.searchinweb.com/search.php?said=bar\u{0a}"))))
(check-sat)
