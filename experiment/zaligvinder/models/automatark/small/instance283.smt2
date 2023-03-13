(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /gate\u{2e}php\u{3f}reg=[a-zA-Z]{15}/U
(assert (str.in_re X (re.++ (str.to_re "/gate.php?reg=") ((_ re.loop 15 15) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/U\u{0a}"))))
; ToolbarUser-Agent\x3AFrom\x3A
(assert (str.in_re X (str.to_re "ToolbarUser-Agent:From:\u{0a}")))
; This\s+\x7D\x7BPassword\x3A\d+
(assert (not (str.in_re X (re.++ (str.to_re "This") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Password:\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
