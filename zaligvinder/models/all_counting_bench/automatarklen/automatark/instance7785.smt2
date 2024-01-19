(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}png([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.png") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^[-+]?[0-9]+[.]?[0-9]*([eE][-+]?[0-9]+)?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; (^(09|9)[1][1-9]\\d{7}$)|(^(09|9)[3][12456]\\d{7}$)
(assert (str.in_re X (re.union (re.++ (re.union (str.to_re "09") (str.to_re "9")) (str.to_re "1") (re.range "1" "9") (str.to_re "\u{5c}") ((_ re.loop 7 7) (str.to_re "d"))) (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "09") (str.to_re "9")) (str.to_re "3") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "4") (str.to_re "5") (str.to_re "6")) (str.to_re "\u{5c}") ((_ re.loop 7 7) (str.to_re "d"))))))
; \b[A-z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "A" "z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "%") (str.to_re "-"))) (str.to_re "@") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 4) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; as\x2Estarware\x2Ecom.*Casino.*LOG.*FilteredHost\x3Ae2give\.com\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (re.++ (str.to_re "as.starware.com") (re.* re.allchar) (str.to_re "Casino") (re.* re.allchar) (str.to_re "LOG") (re.* re.allchar) (str.to_re "FilteredHost:e2give.com/newsurfer4/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
