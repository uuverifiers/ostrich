(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\d+Host\x3A.*communitytipHost\x3AGirafaClient
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.* re.allchar) (str.to_re "communitytipHost:GirafaClient\u{13}\u{0a}"))))
; \x0D\x0ACurrent\x2EearthlinkSpyBuddy
(assert (not (str.in_re X (str.to_re "\u{0d}\u{0a}Current.earthlinkSpyBuddy\u{0a}"))))
; ([1-9]{1,2})?(d|D)([1-9]{1,3})((\+|-)([1-9]{1,3}))?
(assert (not (str.in_re X (re.++ (re.opt ((_ re.loop 1 2) (re.range "1" "9"))) (re.union (str.to_re "d") (str.to_re "D")) ((_ re.loop 1 3) (re.range "1" "9")) (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "-")) ((_ re.loop 1 3) (re.range "1" "9")))) (str.to_re "\u{0a}")))))
; /\u{2e}slk([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.slk") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; security\d+Redirector\u{22}ServerHost\x3AX-Mailer\x3A
(assert (str.in_re X (re.++ (str.to_re "security") (re.+ (re.range "0" "9")) (str.to_re "Redirector\u{22}ServerHost:X-Mailer:\u{13}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
