(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; data\.warezclient\.comHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "data.warezclient.comHost:User-Agent:\u{0a}"))))
; ^([a-z|A-Z]{1}[0-9]{3})[-]([0-9]{3})[-]([0-9]{2})[-]([0-9]{3})[-]([0-9]{1})
(assert (not (str.in_re X (re.++ (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (re.range "a" "z") (str.to_re "|") (re.range "A" "Z"))) ((_ re.loop 3 3) (re.range "0" "9"))))))
; /\u{2e}rjs([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.rjs") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; A-311www3\.addfreestats\.comAttachedX-Mailer\x3A
(assert (str.in_re X (str.to_re "A-311www3.addfreestats.comAttachedX-Mailer:\u{13}\u{0a}")))
; is\x7D\x7BPort\x3A\x7D\x7BUser\x3A
(assert (str.in_re X (str.to_re "is}{Port:}{User:\u{0a}")))
(check-sat)
