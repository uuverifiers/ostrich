(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mppl/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mppl/i\u{0a}"))))
; ^((\(([1-9]{2})\))(\s)?(\.)?(\-)?([0-9]{0,1})?([0-9]{4})(\s)?(\.)?(\-)?([0-9]{4})|(([1-9]{2}))(\s)?(\.)?(\-)?([0-9]{0,1})?([0-9]{4})(\s)?(\.)?(\-)?([0-9]{4}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re ".")) (re.opt (str.to_re "-")) (re.opt (re.opt (re.range "0" "9"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re ".")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "(") ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re ")")) (re.++ ((_ re.loop 2 2) (re.range "1" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re ".")) (re.opt (str.to_re "-")) (re.opt (re.opt (re.range "0" "9"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re ".")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^[A-Z][a-z]+(tz)?(man|berg)$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (re.opt (str.to_re "tz")) (re.union (str.to_re "man") (str.to_re "berg")) (str.to_re "\u{0a}")))))
; Contact\d+Host\x3A[^\n\r]*User-Agent\x3AHost\u{3a}MailHost\u{3a}MSNLOGOVN
(assert (not (str.in_re X (re.++ (str.to_re "Contact") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:Host:MailHost:MSNLOGOVN\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
