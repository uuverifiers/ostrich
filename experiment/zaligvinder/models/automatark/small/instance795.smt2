(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}ogx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.ogx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; www.*tool\x2Eworld2\x2Ecn
(assert (str.in_re X (re.++ (str.to_re "www") (re.* re.allchar) (str.to_re "tool.world2.cn\u{13}\u{0a}"))))
; ^\d{1,5}(\.\d{1,2})?$
(assert (str.in_re X (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; Subject\u{3a}\s+BossUser-Agent\x3ASpediaUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "BossUser-Agent:SpediaUser-Agent:\u{0a}")))))
(check-sat)
