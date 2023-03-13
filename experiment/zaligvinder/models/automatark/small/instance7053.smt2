(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Theef2Host\x3AWordcommunityUser-Agent\x3AHost\x3ATPSystemHost\x3AHost\x3APro
(assert (str.in_re X (str.to_re "Theef2Host:WordcommunityUser-Agent:Host:TPSystemHost:Host:Pro\u{0a}")))
; ^([V|E|J|G|v|e|j|g])([0-9]{5,8})$
(assert (str.in_re X (re.++ (re.union (str.to_re "V") (str.to_re "|") (str.to_re "E") (str.to_re "J") (str.to_re "G") (str.to_re "v") (str.to_re "e") (str.to_re "j") (str.to_re "g")) ((_ re.loop 5 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}sami([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.sami") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
