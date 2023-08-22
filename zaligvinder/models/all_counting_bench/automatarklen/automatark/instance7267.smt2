(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \[DRIVE\w+updates[^\n\r]*\u{22}StarLogger\u{22}User-Agent\x3AJMailUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "[DRIVE") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "updates") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}StarLogger\u{22}User-Agent:JMailUser-Agent:\u{0a}"))))
; /filename=[^\n]*\u{2e}mov/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mov/i\u{0a}")))))
; onBetaHost\u{3a}youRootReferer\x3A
(assert (str.in_re X (str.to_re "onBetaHost:youRootReferer:\u{0a}")))
; www\x2Erichfind\x2Ecom\d+UI2
(assert (str.in_re X (re.++ (str.to_re "www.richfind.com") (re.+ (re.range "0" "9")) (str.to_re "UI2\u{0a}"))))
; ^((0?[1-9]|1[012])(:[0-5]\d){1,2}(\ [AaPp][Mm]))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) ((_ re.loop 1 2) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (str.to_re " ") (re.union (str.to_re "A") (str.to_re "a") (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "M") (str.to_re "m"))))))
(assert (> (str.len X) 10))
(check-sat)
