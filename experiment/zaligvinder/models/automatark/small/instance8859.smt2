(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; started\x2E.*\/cgi-bin\/PopupV
(assert (not (str.in_re X (re.++ (str.to_re "started.") (re.* re.allchar) (str.to_re "/cgi-bin/PopupV\u{0a}")))))
; Basic\s+news\s+CD\x2Furl=Host\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Basic") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "news") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "CD/url=Host:\u{0a}")))))
; ^(((0[1-9]{1})|(1[0-2]{1}))\/?(([0-2]{1}[1-9]{1})|(3[0-1]{1}))\/?(([12]{1}[0-9]{1})?[0-9]{2}) ?(([01]{1}[0-9]{1})|(2[0-4]{1}))\:?([0-5]{1}[0-9]{1}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (str.to_re "1") ((_ re.loop 1 1) (re.range "0" "2")))) (re.opt (str.to_re "/")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (str.to_re "3") ((_ re.loop 1 1) (re.range "0" "1")))) (re.opt (str.to_re "/")) (re.opt (str.to_re " ")) (re.union (re.++ ((_ re.loop 1 1) (re.union (str.to_re "0") (str.to_re "1"))) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "2") ((_ re.loop 1 1) (re.range "0" "4")))) (re.opt (str.to_re ":")) (re.opt (re.++ ((_ re.loop 1 1) (re.union (str.to_re "1") (str.to_re "2"))) ((_ re.loop 1 1) (re.range "0" "9")))) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")))))
; /^(\/\d{8,11})?(\/\d)?\/1[34]\d{8}\.htm$/U
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (re.++ (str.to_re "/") ((_ re.loop 8 11) (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.range "0" "9"))) (str.to_re "/1") (re.union (str.to_re "3") (str.to_re "4")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re ".htm/U\u{0a}")))))
; ^\b\d{2,3}-*\d{7}\b$
(assert (str.in_re X (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.* (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
