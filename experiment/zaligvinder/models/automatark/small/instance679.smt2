(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\w0-9]+( [\w0-9]+)*$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (str.to_re " ") (re.+ (re.union (re.range "0" "9") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}")))))
; Host\u{3a}\w+Host\x3A.*Host\u{3a}ToolbarServerserver\x7D\x7BSysuptime\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "Host:ToolbarServerserver}{Sysuptime:\u{0a}")))))
; (1[8,9]|20)[0-9]{2}
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "8") (str.to_re ",") (str.to_re "9"))) (str.to_re "20")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Spy\dccecaedbebfcaf\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Spy") (re.range "0" "9") (str.to_re "ccecaedbebfcaf.com\u{0a}")))))
; Ready\s+Client\s+MyBrowserHost\u{3a}securityon\x3AHost\x3ARedirector\u{22}ServerHost\x3AX-Mailer\x3A
(assert (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Client") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "MyBrowserHost:securityon:Host:Redirector\u{22}ServerHost:X-Mailer:\u{13}\u{0a}"))))
(check-sat)
