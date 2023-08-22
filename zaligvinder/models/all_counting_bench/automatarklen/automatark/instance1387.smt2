(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-zA-Z0-1@.\s]{1,255})$
(assert (str.in_re X (re.++ ((_ re.loop 1 255) (re.union (re.range "1" "z") (re.range "A" "Z") (re.range "0" "1") (str.to_re "@") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; this\s+MyBrowser\d+Redirector\u{22}ServerHost\x3AX-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "this") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "MyBrowser") (re.+ (re.range "0" "9")) (str.to_re "Redirector\u{22}ServerHost:X-Mailer:\u{13}\u{0a}")))))
; /\u{2e}xlsx([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.xlsx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; HXDownload\s+Host\x3AArcadeHourspjpoptwql\u{2f}rlnjFrom\x3A
(assert (str.in_re X (re.++ (str.to_re "HXDownload") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:ArcadeHourspjpoptwql/rlnjFrom:\u{0a}"))))
; ^(\d{4})\D?(0[1-9]|1[0-2])\D?([12]\d|0[1-9]|3[01])(\D?([01]\d|2[0-3])\D?([0-5]\d)\D?([0-5]\d)?)?$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.opt (re.++ (re.opt (re.comp (re.range "0" "9"))) (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.opt (re.comp (re.range "0" "9"))) (re.opt (re.comp (re.range "0" "9"))) (re.opt (re.++ (re.range "0" "5") (re.range "0" "9"))) (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
