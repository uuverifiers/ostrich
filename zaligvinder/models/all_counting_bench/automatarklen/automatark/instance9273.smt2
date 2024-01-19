(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3Awww\x2Emyarmory\x2EcomHost\x3AUser-Agent\u{3a}Host\x3AportAuthorization\u{3a}\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (str.to_re "User-Agent:www.myarmory.comHost:User-Agent:Host:portAuthorization:/newsurfer4/\u{0a}"))))
; /\u{2e}dmg([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.dmg") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^((\d[-. ]?)?((\(\d{3}\))|\d{3}))?[-. ]?\d{3}[-. ]?\d{4}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (re.++ (re.range "0" "9") (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))))) (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
