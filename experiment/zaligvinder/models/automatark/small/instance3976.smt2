(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}wmf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.wmf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^[A-z]?\d{8}[A-z]$
(assert (not (str.in_re X (re.++ (re.opt (re.range "A" "z")) ((_ re.loop 8 8) (re.range "0" "9")) (re.range "A" "z") (str.to_re "\u{0a}")))))
; <([^<>\s]*)(\s[^<>]*)?>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* (re.union (str.to_re "<") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.* (re.union (str.to_re "<") (str.to_re ">"))))) (str.to_re ">\u{0a}")))))
; /^\/\d{2,4}\.xap$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re ".xap/U\u{0a}")))))
; ^([Vv]+(erdade(iro)?)?|[Ff]+(als[eo])?|[Tt]+(rue)?|0|[\+\-]?1)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.+ (re.union (str.to_re "V") (str.to_re "v"))) (re.opt (re.++ (str.to_re "erdade") (re.opt (str.to_re "iro"))))) (re.++ (re.+ (re.union (str.to_re "F") (str.to_re "f"))) (re.opt (re.++ (str.to_re "als") (re.union (str.to_re "e") (str.to_re "o"))))) (re.++ (re.+ (re.union (str.to_re "T") (str.to_re "t"))) (re.opt (str.to_re "rue"))) (str.to_re "0") (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (str.to_re "1"))) (str.to_re "\u{0a}")))))
(check-sat)
