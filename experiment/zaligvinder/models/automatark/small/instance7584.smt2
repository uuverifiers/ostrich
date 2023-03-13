(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$[+-]?([0-9]+|[0-9]{1,3}(,[0-9]{3})*)(\.[0-9]{1,2})?$
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; .+\.([^.]+)$
(assert (not (str.in_re X (re.++ (re.+ re.allchar) (str.to_re ".") (re.+ (re.comp (str.to_re "."))) (str.to_re "\u{0a}")))))
; FreeAccessBar\s+hostie[^\n\r]*CodeguruBrowser\dStableWeb-MailUser-Agent\x3A195\.225\.Subject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "FreeAccessBar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hostie") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "CodeguruBrowser") (re.range "0" "9") (str.to_re "StableWeb-MailUser-Agent:195.225.Subject:\u{0a}")))))
; /^\u{2f}\d{3}\u{2f}\d{3}\u{2e}html$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".html/U\u{0a}")))))
; /filename=[^\n]*\u{2e}qt/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".qt/i\u{0a}")))))
(check-sat)
