(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x7D\x7BPort\x3AHost\x3Amqnqgijmng\u{2f}ojNavhelperUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "}{Port:Host:mqnqgijmng/ojNavhelperUser-Agent:\u{0a}"))))
; aohobygi\u{2f}zwiw\s+\+The\+password\+is\x3A
(assert (not (str.in_re X (re.++ (str.to_re "aohobygi/zwiw") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "+The+password+is:\u{0a}")))))
; /filename=[^\n]*\u{2e}swf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".swf/i\u{0a}")))))
; (077|078|079)\s?\d{2}\s?\d{6}
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}07") (re.union (str.to_re "7") (str.to_re "8") (str.to_re "9"))))))
; \u{28}BDLL\u{29}Googledll\x3F
(assert (str.in_re X (str.to_re "(BDLL)\u{13}Googledll?\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
