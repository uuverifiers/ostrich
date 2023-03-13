(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{0,2}(\.\d{1,2})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ([0-9a-z_-]+[\.][0-9a-z_-]{1,3})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "a" "z") (str.to_re "_") (str.to_re "-")))))))
; /filename=[^\n]*\u{2e}lnk/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".lnk/i\u{0a}")))))
; /\u{2e}pmd([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.pmd") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; Flooded\s+Host\x3A\s+AppName\x2FGRSI\|Server\|Host\x3Aorigin\x3DsidefindHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Flooded") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AppName/GRSI|Server|\u{13}Host:origin=sidefindHost:User-Agent:\u{0a}")))))
(check-sat)
