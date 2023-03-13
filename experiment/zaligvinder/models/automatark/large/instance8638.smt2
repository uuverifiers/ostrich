(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; data\.warezclient\.comHost\x3AUser-Agent\x3A
(assert (str.in_re X (str.to_re "data.warezclient.comHost:User-Agent:\u{0a}")))
; /\u{2e}gni([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.gni") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^(\d{3,})\s?(\w{0,5})\s([a-zA-Z]{2,30})\s([a-zA-Z]{2,15})\.?\s?(\w{0,5})$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 5) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 30) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 15) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (str.to_re ".")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 5) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) (re.* (re.range "0" "9")))))
; Host\x3A\dKeyloggercargo=
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Keyloggercargo=\u{0a}")))))
; Authorization\u{3a}\d+lnzzlnbk\u{2f}pkrm\.fin
(assert (str.in_re X (re.++ (str.to_re "Authorization:") (re.+ (re.range "0" "9")) (str.to_re "lnzzlnbk/pkrm.fin\u{0a}"))))
(check-sat)
