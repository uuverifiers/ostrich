(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[?&]filename=[^&]*?\u{2e}\u{2e}\u{2f}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "?") (str.to_re "&")) (str.to_re "filename=") (re.* (re.comp (str.to_re "&"))) (str.to_re "..//Ui\u{0a}")))))
; ([a-zA-Z]{2}[0-9]{1,2}\s{0,1}[0-9]{1,2}[a-zA-Z]{2})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))))
; \x7D\x7BPort\x3AHost\x3Amqnqgijmng\u{2f}ojNavhelperUser-Agent\x3A
(assert (str.in_re X (str.to_re "}{Port:Host:mqnqgijmng/ojNavhelperUser-Agent:\u{0a}")))
; ^[-]?\d*(\.\d*)$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}.") (re.* (re.range "0" "9")))))
; [\u{80}-\xFF]
(assert (not (str.in_re X (re.++ (re.range "\u{80}" "\u{ff}") (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
