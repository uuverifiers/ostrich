(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}rmp([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.rmp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^\#?[A-Fa-f0-9]{3}([A-Fa-f0-9]{3})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "#")) ((_ re.loop 3 3) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (re.opt ((_ re.loop 3 3) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; (\/\/-->\s*)?<\/?SCRIPT([^>]*)>(\s*<!--\s)?
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "//-->") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "<") (re.opt (str.to_re "/")) (str.to_re "SCRIPT") (re.* (re.comp (str.to_re ">"))) (str.to_re ">") (re.opt (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "<!--") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}"))))
; A-311Host\x3Alnzzlnbk\u{2f}pkrm\.finSubject\u{3a}
(assert (str.in_re X (str.to_re "A-311Host:lnzzlnbk/pkrm.finSubject:\u{0a}")))
(check-sat)
