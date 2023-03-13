(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^GET \x2F3010[0-9A-F]{166}00000001/
(assert (str.in_re X (re.++ (str.to_re "/GET /3010") ((_ re.loop 166 166) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "00000001/\u{0a}"))))
; aohobygi\u{2f}zwiw\s+\+The\+password\+is\x3A
(assert (str.in_re X (re.++ (str.to_re "aohobygi/zwiw") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "+The+password+is:\u{0a}"))))
(check-sat)
