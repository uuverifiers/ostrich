(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Agent.*as\x2Estarware\x2Ecom\s+ServerToolbarcojud\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Agent") (re.* re.allchar) (str.to_re "as.starware.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ServerToolbarcojud.dmcast.com\u{0a}")))))
; c\.goclick\.com[^\n\r]*is\s+URLBlaze
(assert (str.in_re X (re.++ (str.to_re "c.goclick.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlaze\u{0a}"))))
; www\x2Ealtnet\x2Ecom[^\n\r]*Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "www.altnet.com\u{1b}") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}")))))
; ^(\+27|27|0)[0-9]{2}( |-)?[0-9]{3}( |-)?[0-9]{4}( |-)?(x[0-9]+)?(ext[0-9]+)?
(assert (not (str.in_re X (re.++ (re.union (str.to_re "+27") (str.to_re "27") (str.to_re "0")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (re.opt (re.++ (str.to_re "x") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "ext") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; User-Agent\x3A\s+\x7D\x7BPassword\x3AAnal
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Password:\u{1b}Anal\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
