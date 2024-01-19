(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AUser-Agent\u{3a}
(assert (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}")))
; Host\x3AlogUser-Agent\x3AonSubject\x3A
(assert (not (str.in_re X (str.to_re "Host:logUser-Agent:onSubject:\u{0a}"))))
; <[^>\s]*\bauthor\b[^>]*>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* (re.union (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "author") (re.* (re.comp (str.to_re ">"))) (str.to_re ">\u{0a}")))))
; User-Agent\x3A\w+\u{0d}\u{0a}subject=GhostVoice
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0d}\u{0a}subject=GhostVoice\u{0a}"))))
; ^(([0-9]{3})[-]?)*[0-9]{6,7}$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")))) ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
