(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}jnlp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jnlp/i\u{0a}"))))
; ^([0-9]*|\d*\.\d{1}?\d*)$
(assert (not (str.in_re X (re.++ (re.union (re.* (re.range "0" "9")) (re.++ (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /\u{2e}dvr-ms([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.dvr-ms") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; Toolbar[^\n\r]*tvshowtickets\w+weatherHost\x3AUser-Agent\x3Atwfofrfzlugq\u{2f}eve\.qd
(assert (not (str.in_re X (re.++ (str.to_re "Toolbar") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "tvshowtickets") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "weatherHost:User-Agent:twfofrfzlugq/eve.qd\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
