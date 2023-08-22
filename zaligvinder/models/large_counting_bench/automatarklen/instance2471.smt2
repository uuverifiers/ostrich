(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/setup.cgi.*?TimeToLive=[^&]*?(%60|\u{60})/iU
(assert (str.in_re X (re.++ (str.to_re "//setup") re.allchar (str.to_re "cgi") (re.* re.allchar) (str.to_re "TimeToLive=") (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "%60") (str.to_re "`")) (str.to_re "/iU\u{0a}"))))
; /filename=[^\n]*\u{2e}ogv/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ogv/i\u{0a}"))))
; IDENTIFY.*\x2Fezsb\d+X-Mailer\x3A
(assert (str.in_re X (re.++ (str.to_re "IDENTIFY") (re.* re.allchar) (str.to_re "/ezsb") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer:\u{13}\u{0a}"))))
; /\u{2f}[a-z-_]{90,}\u{2e}(html|php)$/U
(assert (str.in_re X (re.++ (str.to_re "//.") (re.union (str.to_re "html") (str.to_re "php")) (str.to_re "/U\u{0a}") ((_ re.loop 90 90) (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "_"))) (re.* (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "_"))))))
(assert (< 200 (str.len X)))
(check-sat)
