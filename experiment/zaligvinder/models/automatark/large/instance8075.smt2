(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([^\.\?\!]*)[\.\?\!]
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re ".") (str.to_re "?") (str.to_re "!"))) (re.union (str.to_re ".") (str.to_re "?") (str.to_re "!")) (str.to_re "\u{0a}"))))
; ^([0]{0,1}[0-7]{3})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "0")) ((_ re.loop 3 3) (re.range "0" "7"))))))
; /\u{2e}xpm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.xpm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /^Host:\s*?[a-f0-9]{63,64}\./Him
(assert (not (str.in_re X (re.++ (str.to_re "/Host:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 63 64) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "./Him\u{0a}")))))
(check-sat)
