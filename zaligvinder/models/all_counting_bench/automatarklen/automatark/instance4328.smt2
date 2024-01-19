(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\u{2e}2-seek\u{2e}com\u{2f}search\s+TPSystem
(assert (str.in_re X (re.++ (str.to_re "www.2-seek.com/search") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TPSystem\u{0a}"))))
; IDENTIFY.*\x2Fezsb\d+X-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "IDENTIFY") (re.* re.allchar) (str.to_re "/ezsb") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer:\u{13}\u{0a}")))))
; /\u{2f}\u{24}\{\u{23}[^\u{2f}{}]+?\}(\.action)?\u{2f}?$/miU
(assert (not (str.in_re X (re.++ (str.to_re "//${#") (re.+ (re.union (str.to_re "/") (str.to_re "{") (str.to_re "}"))) (str.to_re "}") (re.opt (str.to_re ".action")) (re.opt (str.to_re "/")) (str.to_re "/miU\u{0a}")))))
; ^(\+)?([9]{1}[2]{1})?-? ?(\()?([0]{1})?[1-9]{2,4}(\))?-? ??(\()?[1-9]{4,7}(\))?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re "9")) ((_ re.loop 1 1) (str.to_re "2")))) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) (re.opt ((_ re.loop 1 1) (str.to_re "0"))) ((_ re.loop 2 4) (re.range "1" "9")) (re.opt (str.to_re ")")) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) ((_ re.loop 4 7) (re.range "1" "9")) (re.opt (str.to_re ")")) (str.to_re "\u{0a}")))))
; SSKCstech\x2Eweb-nexus\x2Enet
(assert (not (str.in_re X (str.to_re "SSKCstech.web-nexus.net\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
