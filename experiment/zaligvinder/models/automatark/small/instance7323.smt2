(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([a-zA-Z]{2}[0-9]{1,2}\s{0,1}[0-9]{1,2}[a-zA-Z]{2})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))))
; /filename=[^\n]*\u{2e}vwr/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vwr/i\u{0a}"))))
; User-Agent\x3Awww\x2Emyarmory\x2EcomHost\x3AUser-Agent\u{3a}Host\x3AportAuthorization\u{3a}\x2Fnewsurfer4\x2F
(assert (str.in_re X (str.to_re "User-Agent:www.myarmory.comHost:User-Agent:Host:portAuthorization:/newsurfer4/\u{0a}")))
(check-sat)
